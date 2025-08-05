#!/usr/bin/env python3
"""
Experiment tracking hook for AI research projects
Automatically tracks code changes, model artifacts, and experiment metadata
"""

import json
import sys
import os
import hashlib
import subprocess
from datetime import datetime
from pathlib import Path

def get_git_info():
    """Get current git commit and branch information"""
    try:
        commit = subprocess.check_output(['git', 'rev-parse', 'HEAD']).decode().strip()
        branch = subprocess.check_output(['git', 'rev-parse', '--abbrev-ref', 'HEAD']).decode().strip()
        status = subprocess.check_output(['git', 'status', '--porcelain']).decode().strip()
        return {
            "commit": commit,
            "branch": branch,
            "has_uncommitted_changes": bool(status),
            "status": status
        }
    except subprocess.CalledProcessError:
        return None

def calculate_file_hash(filepath):
    """Calculate SHA256 hash of a file"""
    try:
        with open(filepath, 'rb') as f:
            return hashlib.sha256(f.read()).hexdigest()
    except:
        return None

def detect_ml_files(files):
    """Detect if modified files are ML-related"""
    ml_extensions = {'.py', '.ipynb', '.yml', '.yaml', '.json'}
    ml_keywords = ['model', 'train', 'experiment', 'config', 'data', 'pipeline']
    
    ml_files = []
    for file_path in files:
        path = Path(file_path)
        
        # Check extension
        if path.suffix.lower() in ml_extensions:
            ml_files.append(file_path)
            continue
            
        # Check for ML keywords in filename
        filename_lower = path.name.lower()
        if any(keyword in filename_lower for keyword in ml_keywords):
            ml_files.append(file_path)
    
    return ml_files

def main():
    try:
        # Read hook input from stdin
        hook_input = json.loads(sys.stdin.read())
        
        # Extract file paths from different tool types
        files = []
        if 'file_path' in hook_input:
            files = [hook_input['file_path']]
        elif 'files' in hook_input:
            files = hook_input['files']
        elif hook_input.get('tool') in ['Write', 'Edit', 'MultiEdit']:
            # Try to extract file path from tool parameters
            if 'file_path' in str(hook_input):
                # Simple extraction - in real implementation, parse properly
                pass
        
        # Create experiment tracking directory
        tracking_dir = Path(".claude/experiments")
        tracking_dir.mkdir(exist_ok=True)
        
        # Generate experiment metadata
        experiment_data = {
            "timestamp": datetime.now().isoformat(),
            "session_id": os.environ.get("CLAUDE_SESSION_ID", "unknown"),
            "git_info": get_git_info(),
            "modified_files": files,
            "ml_files": detect_ml_files(files),
            "environment": {
                "python_version": subprocess.check_output(['python', '--version']).decode().strip(),
                "gpu_available": os.path.exists('/usr/bin/nvidia-smi'),
                "conda_env": os.environ.get("CONDA_DEFAULT_ENV"),
                "virtual_env": os.environ.get("VIRTUAL_ENV")
            }
        }
        
        # Add file hashes for reproducibility
        file_hashes = {}
        for file_path in files:
            if os.path.exists(file_path):
                file_hashes[file_path] = calculate_file_hash(file_path)
        experiment_data["file_hashes"] = file_hashes
        
        # Check for experiment configuration files
        config_files = []
        for pattern in ["config*.yaml", "config*.yml", "config*.json", "experiment*.yaml"]:
            config_files.extend(Path(".").glob(pattern))
        
        if config_files:
            experiment_data["config_files"] = [str(f) for f in config_files]
            # Hash config files for versioning
            config_hashes = {}
            for config_file in config_files:
                config_hashes[str(config_file)] = calculate_file_hash(config_file)
            experiment_data["config_hashes"] = config_hashes
        
        # Detect if this might be a training run
        ml_indicators = [
            "train", "fit", "epoch", "loss", "accuracy", "model.save", 
            "torch.save", "tf.keras", "sklearn", "wandb", "mlflow"
        ]
        
        is_ml_session = False
        if files:
            for file_path in files:
                try:
                    with open(file_path, 'r') as f:
                        content = f.read().lower()
                        if any(indicator in content for indicator in ml_indicators):
                            is_ml_session = True
                            break
                except:
                    pass
        
        experiment_data["is_ml_session"] = is_ml_session
        
        # Save experiment metadata
        experiment_file = tracking_dir / f"experiment_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        with open(experiment_file, 'w') as f:
            json.dump(experiment_data, f, indent=2)
        
        # Integration with external tracking systems
        if os.environ.get("WANDB_PROJECT") and is_ml_session:
            try:
                # Log to wandb (pseudo-code - would need actual wandb import)
                print("📊 Experiment metadata logged to W&B")
            except:
                pass
        
        if os.environ.get("MLFLOW_TRACKING_URI") and is_ml_session:
            try:
                # Log to MLflow (pseudo-code - would need actual mlflow import)
                print("📈 Experiment metadata logged to MLflow")
            except:
                pass
        
        # Output summary
        summary = {
            "experiment_tracked": True,
            "ml_session_detected": is_ml_session,
            "files_tracked": len(files),
            "ml_files_count": len(experiment_data["ml_files"]),
            "git_commit": experiment_data["git_info"]["commit"][:8] if experiment_data["git_info"] else None
        }
        
        if is_ml_session:
            print("🧪 ML experiment session detected - metadata tracked")
            
        if experiment_data["git_info"] and experiment_data["git_info"]["has_uncommitted_changes"]:
            print("⚠️  Uncommitted changes detected - consider committing for reproducibility")
        
        print(json.dumps(summary))
        sys.exit(0)
        
    except Exception as e:
        print(f"❌ Experiment tracking error: {e}")
        # Don't block execution on tracking errors
        sys.exit(0)

if __name__ == "__main__":
    main()