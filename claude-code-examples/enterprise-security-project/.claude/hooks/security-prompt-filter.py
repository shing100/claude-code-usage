#!/usr/bin/env python3
"""
Security prompt filter hook for Claude Code
Validates user prompts for security compliance and potential risks
"""

import json
import sys
import re
import logging
from datetime import datetime
from pathlib import Path

# Configure logging
log_dir = Path(".claude/logs")
log_dir.mkdir(exist_ok=True)
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler(log_dir / "security-filter.log"),
        logging.StreamHandler()
    ]
)

def main():
    try:
        # Read hook input from stdin
        hook_input = json.loads(sys.stdin.read())
        prompt = hook_input.get("prompt", "")
        
        # Security risk patterns to detect
        risk_patterns = [
            # Credential exposure
            (r'(?i)(password|secret|key|token)\s*[=:]\s*["\']?[a-zA-Z0-9]{8,}', "CREDENTIAL_EXPOSURE"),
            # Network scanning/reconnaissance
            (r'(?i)(nmap|port\s+scan|vulnerability\s+scan)', "NETWORK_SCANNING"),
            # SQL injection attempts
            (r'(?i)(union\s+select|drop\s+table|delete\s+from)', "SQL_INJECTION"),
            # Shell injection
            (r'(?i)(\|\s*sh|\|\s*bash|`.*`|\$\(.*\))', "SHELL_INJECTION"),
            # Suspicious network requests
            (r'(?i)(curl.*-X\s+POST|wget.*--post)', "SUSPICIOUS_NETWORK"),
            # Malicious file operations
            (r'(?i)(rm\s+-rf|format\s+c:|del\s+/s)', "DESTRUCTIVE_OPERATIONS"),
        ]
        
        # Check for security risks
        detected_risks = []
        for pattern, risk_type in risk_patterns:
            if re.search(pattern, prompt):
                detected_risks.append(risk_type)
                logging.warning(f"Security risk detected: {risk_type}")
        
        # Check for sensitive information requests
        sensitive_patterns = [
            r'(?i)(ssh\s+key|private\s+key|certificate)',
            r'(?i)(database\s+password|admin\s+credentials)',
            r'(?i)(api\s+key|access\s+token)',
        ]
        
        for pattern in sensitive_patterns:
            if re.search(pattern, prompt):
                detected_risks.append("SENSITIVE_INFO_REQUEST")
                logging.warning("Sensitive information request detected")
                break
        
        # Security compliance checks
        compliance_violations = []
        
        # Check for requests that might violate data privacy
        privacy_patterns = [
            r'(?i)(personal\s+data|pii|personally\s+identifiable)',
            r'(?i)(social\s+security|credit\s+card|ssn)',
            r'(?i)(gdpr|hipaa|pci\s+dss)',
        ]
        
        for pattern in privacy_patterns:
            if re.search(pattern, prompt):
                compliance_violations.append("DATA_PRIVACY")
                logging.info("Data privacy context detected - ensuring compliance")
                break
        
        # Log the interaction
        log_entry = {
            "timestamp": datetime.now().isoformat(),
            "prompt_length": len(prompt),
            "detected_risks": detected_risks,
            "compliance_violations": compliance_violations,
            "action": "BLOCKED" if detected_risks else "ALLOWED"
        }
        
        with open(log_dir / "security-audit.json", "a") as f:
            f.write(json.dumps(log_entry) + "\n")
        
        # Block if high-risk patterns detected
        if detected_risks:
            error_msg = f"🚫 Security policy violation detected: {', '.join(detected_risks)}"
            print(json.dumps({
                "error": error_msg,
                "blocked": True,
                "risks": detected_risks
            }))
            sys.exit(2)  # Block execution
        
        # Allow with warning for compliance items
        if compliance_violations:
            warning_msg = f"⚠️  Compliance context detected: {', '.join(compliance_violations)}"
            print(json.dumps({
                "warning": warning_msg,
                "compliance_note": "Ensure all responses comply with relevant regulations"
            }))
        
        # Allow execution
        logging.info("Prompt validated - no security risks detected")
        sys.exit(0)
        
    except Exception as e:
        logging.error(f"Security filter error: {e}")
        # Fail safe - allow execution but log error
        print(json.dumps({"error": f"Security filter error: {e}"}))
        sys.exit(0)

if __name__ == "__main__":
    main()