#!/bin/bash

# User prompt submit hook for Claude Code
# This script runs when the user submits a prompt to Claude
# Use this to analyze user intent, prepare context, or validate input

set -euo pipefail

# Configuration
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
LOG_FILE="${REPO_ROOT}/.claude/logs/user-prompt-submit.log"
CONTEXT_FILE="${REPO_ROOT}/.claude/context/session-context.json"

# Ensure directories exist
mkdir -p "$(dirname "$LOG_FILE")"
mkdir -p "$(dirname "$CONTEXT_FILE")"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

# Function to extract user prompt from stdin or arguments
get_user_prompt() {
    local prompt=""
    
    # Check if prompt is passed as arguments
    if [[ $# -gt 0 ]]; then
        prompt="$*"
    else
        # Read from stdin if available
        if [[ -p /dev/stdin ]]; then
            prompt=$(cat)
        fi
    fi
    
    echo "$prompt"
}

# Function to analyze prompt intent
analyze_prompt_intent() {
    local prompt="$1"
    local intent="general"
    
    # Security-related keywords
    if echo "$prompt" | grep -iE "(security|vulnerability|audit|penetration|exploit|hack)" > /dev/null; then
        intent="security"
    # Testing-related keywords
    elif echo "$prompt" | grep -iE "(test|testing|unit test|integration|e2e|coverage)" > /dev/null; then
        intent="testing"
    # Documentation-related keywords
    elif echo "$prompt" | grep -iE "(document|docs|readme|api doc|comment|explain)" > /dev/null; then
        intent="documentation"
    # Deployment-related keywords
    elif echo "$prompt" | grep -iE "(deploy|deployment|ci/cd|pipeline|staging|production)" > /dev/null; then
        intent="deployment"
    # Performance-related keywords
    elif echo "$prompt" | grep -iE "(performance|optimize|slow|fast|benchmark|profile)" > /dev/null; then
        intent="performance"
    # Bug fixing keywords
    elif echo "$prompt" | grep -iE "(bug|fix|error|issue|problem|debug)" > /dev/null; then
        intent="debugging"
    # Feature development keywords
    elif echo "$prompt" | grep -iE "(implement|create|build|add|feature|new)" > /dev/null; then
        intent="development"
    # Code review keywords
    elif echo "$prompt" | grep -iE "(review|refactor|clean|improve|quality)" > /dev/null; then
        intent="code_review"
    fi
    
    echo "$intent"
}

# Function to gather project context
gather_project_context() {
    local context="{}"
    
    # Detect project type
    local project_type="unknown"
    if [[ -f "package.json" ]]; then
        project_type="nodejs"
    elif [[ -f "pyproject.toml" ]] || [[ -f "requirements.txt" ]] || [[ -f "setup.py" ]]; then
        project_type="python"
    elif [[ -f "Cargo.toml" ]]; then
        project_type="rust"
    elif [[ -f "go.mod" ]]; then
        project_type="go"
    elif [[ -f "pom.xml" ]] || [[ -f "build.gradle" ]]; then
        project_type="java"
    elif [[ -f "Gemfile" ]]; then
        project_type="ruby"
    elif [[ -f "composer.json" ]]; then
        project_type="php"
    fi
    
    # Get git information
    local git_branch="unknown"
    local git_status="unknown"
    if git rev-parse --git-dir > /dev/null 2>&1; then
        git_branch=$(git branch --show-current 2>/dev/null || echo "unknown")
        if git diff-index --quiet HEAD -- 2>/dev/null; then
            git_status="clean"
        else
            git_status="dirty"
        fi
    fi
    
    # Count files by type
    local file_counts=""
    if command -v find > /dev/null 2>&1; then
        file_counts=$(cat <<EOF
{
  "python": $(find . -name "*.py" -type f | wc -l),
  "javascript": $(find . -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" -type f | wc -l),
  "rust": $(find . -name "*.rs" -type f | wc -l),
  "go": $(find . -name "*.go" -type f | wc -l),
  "total": $(find . -type f ! -path "./.git/*" ! -path "./node_modules/*" ! -path "./.venv/*" | wc -l)
}
EOF
        )
    fi
    
    # Build context object
    context=$(cat <<EOF
{
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "project_type": "$project_type",
  "git_branch": "$git_branch",
  "git_status": "$git_status",
  "working_directory": "$(pwd)",
  "file_counts": $file_counts
}
EOF
    )
    
    echo "$context"
}

# Function to suggest relevant agents based on intent
suggest_agents() {
    local intent="$1"
    local suggestions=""
    
    case "$intent" in
        "security")
            suggestions="security-auditor, backend-developer"
            ;;
        "testing")
            suggestions="qa-engineer, frontend-developer, backend-developer"
            ;;
        "documentation")
            suggestions="documentation-writer, python-expert"
            ;;
        "deployment")
            suggestions="devops-engineer, backend-developer"
            ;;
        "performance")
            suggestions="backend-developer, frontend-developer, devops-engineer"
            ;;
        "debugging")
            suggestions="qa-engineer, backend-developer, frontend-developer"
            ;;
        "development")
            suggestions="frontend-developer, backend-developer, python-expert"
            ;;
        "code_review")
            suggestions="security-auditor, qa-engineer, python-expert"
            ;;
        *)
            suggestions="frontend-developer, backend-developer"
            ;;
    esac
    
    echo "$suggestions"
}

# Function to check for potential security concerns in prompt
check_security_concerns() {
    local prompt="$1"
    
    # Check for potential sensitive information
    if echo "$prompt" | grep -iE "(password|token|key|secret|credential)" > /dev/null; then
        log "WARNING: Prompt contains potential sensitive information keywords"
        return 1
    fi
    
    # Check for potentially dangerous commands
    if echo "$prompt" | grep -iE "(rm -rf|delete|drop|truncate)" > /dev/null; then
        log "WARNING: Prompt contains potentially destructive commands"
        return 1
    fi
    
    return 0
}

# Function to prepare development environment
prepare_environment() {
    local intent="$1"
    
    # Ensure common directories exist
    mkdir -p .claude/logs
    mkdir -p .claude/context
    mkdir -p .claude/cache
    
    # Based on intent, prepare specific environment
    case "$intent" in
        "testing")
            # Ensure test directories exist
            mkdir -p tests
            mkdir -p test
            ;;
        "documentation")
            # Ensure docs directory exists
            mkdir -p docs
            ;;
        "deployment")
            # Ensure CI/CD related directories exist
            mkdir -p .github/workflows
            mkdir -p scripts
            ;;
    esac
}

# Function to save session context
save_session_context() {
    local prompt="$1"
    local intent="$2"
    local context="$3"
    local suggestions="$4"
    
    local session_data=$(cat <<EOF
{
  "session_id": "$(date +%s)",
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "user_prompt": $(echo "$prompt" | jq -R .),
  "detected_intent": "$intent",
  "suggested_agents": "$suggestions",
  "project_context": $context
}
EOF
    )
    
    echo "$session_data" > "$CONTEXT_FILE"
}

# Main execution
main() {
    log "User prompt submit hook starting..."
    
    # Get the user prompt
    local prompt
    prompt=$(get_user_prompt "$@")
    
    if [[ -z "$prompt" ]]; then
        log "No prompt detected"
        return 0
    fi
    
    log "Processing user prompt (length: ${#prompt} characters)"
    
    # Analyze prompt intent
    local intent
    intent=$(analyze_prompt_intent "$prompt")
    log "Detected intent: $intent"
    
    # Check for security concerns
    if ! check_security_concerns "$prompt"; then
        log "Security concerns detected in prompt"
    fi
    
    # Gather project context
    local context
    context=$(gather_project_context)
    
    # Suggest relevant agents
    local suggestions
    suggestions=$(suggest_agents "$intent")
    log "Suggested agents: $suggestions"
    
    # Prepare environment based on intent
    prepare_environment "$intent"
    
    # Save session context
    save_session_context "$prompt" "$intent" "$context" "$suggestions"
    
    # Provide helpful output to the user (this goes to Claude)
    cat <<EOF

## Prompt Analysis
- **Intent**: $intent
- **Suggested Agents**: $suggestions
- **Project Type**: $(echo "$context" | jq -r '.project_type')
- **Git Status**: $(echo "$context" | jq -r '.git_status')

## Available Resources
- Session context saved to: $CONTEXT_FILE
- Logs available at: $LOG_FILE

EOF
    
    log "User prompt submit hook completed"
    return 0
}

# Run main function
main "$@"