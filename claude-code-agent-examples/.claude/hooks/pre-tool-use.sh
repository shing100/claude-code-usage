#!/bin/bash

# Pre-tool-use hook for Claude Code
# This script runs before any tool is used by Claude
# Use this to validate project state, run checks, or prepare the environment

set -euo pipefail

# Configuration
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
LOG_FILE="${REPO_ROOT}/.claude/logs/pre-tool-use.log"

# Ensure log directory exists
mkdir -p "$(dirname "$LOG_FILE")"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

log "Pre-tool-use hook starting..."

# Function to check if we're in a git repository
check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        log "WARNING: Not in a git repository"
        return 1
    fi
    return 0
}

# Function to check for uncommitted changes
check_uncommitted_changes() {
    if ! git diff-index --quiet HEAD -- 2>/dev/null; then
        log "INFO: Uncommitted changes detected"
        # Optional: You can make this a warning or error based on your workflow
        return 0
    fi
    return 0
}

# Function to check if tests are passing
check_tests() {
    local test_command=""
    
    # Detect test command based on project type
    if [[ -f "package.json" ]]; then
        if jq -e '.scripts.test' package.json > /dev/null 2>&1; then
            test_command="npm test"
        fi
    elif [[ -f "pyproject.toml" ]] || [[ -f "requirements.txt" ]] || [[ -f "setup.py" ]]; then
        if command -v pytest > /dev/null 2>&1; then
            test_command="pytest --tb=short -q"
        elif command -v python > /dev/null 2>&1; then
            test_command="python -m unittest discover -s tests -p '*test*.py' -q"
        fi
    elif [[ -f "Cargo.toml" ]]; then
        test_command="cargo test --quiet"
    elif [[ -f "go.mod" ]]; then
        test_command="go test ./... -short"
    elif [[ -f "Makefile" ]]; then
        if grep -q "^test:" Makefile; then
            test_command="make test"
        fi
    fi
    
    if [[ -n "$test_command" ]]; then
        log "Running tests: $test_command"
        if ! eval "$test_command" > /dev/null 2>&1; then
            log "ERROR: Tests are failing. Please fix tests before proceeding."
            return 1
        else
            log "INFO: Tests are passing"
        fi
    else
        log "INFO: No test command detected, skipping test check"
    fi
    
    return 0
}

# Function to check code quality/linting
check_code_quality() {
    local lint_command=""
    
    # Detect linting command based on project type
    if [[ -f "package.json" ]]; then
        if jq -e '.scripts.lint' package.json > /dev/null 2>&1; then
            lint_command="npm run lint"
        elif command -v eslint > /dev/null 2>&1; then
            lint_command="eslint ."
        fi
    elif [[ -f "pyproject.toml" ]] || [[ -f ".flake8" ]] || [[ -f "setup.cfg" ]]; then
        if command -v ruff > /dev/null 2>&1; then
            lint_command="ruff check ."
        elif command -v flake8 > /dev/null 2>&1; then
            lint_command="flake8"
        elif command -v pylint > /dev/null 2>&1; then
            lint_command="pylint **/*.py"
        fi
    elif [[ -f "Cargo.toml" ]]; then
        lint_command="cargo clippy --quiet"
    elif [[ -f "go.mod" ]]; then
        if command -v golangci-lint > /dev/null 2>&1; then
            lint_command="golangci-lint run"
        elif command -v go > /dev/null 2>&1; then
            lint_command="go vet ./..."
        fi
    elif [[ -f "Makefile" ]]; then
        if grep -q "^lint:" Makefile; then
            lint_command="make lint"
        fi
    fi
    
    if [[ -n "$lint_command" ]]; then
        log "Running linter: $lint_command"
        if ! eval "$lint_command" > /dev/null 2>&1; then
            log "WARNING: Linting issues detected. Consider fixing before proceeding."
            # Note: This is a warning, not an error, so we don't exit
        else
            log "INFO: Linting checks passed"
        fi
    else
        log "INFO: No linting command detected, skipping quality check"
    fi
    
    return 0
}

# Function to check dependencies for security issues
check_security() {
    if [[ -f "package.json" ]] && command -v npm > /dev/null 2>&1; then
        log "Running npm security audit..."
        if ! npm audit --audit-level=high > /dev/null 2>&1; then
            log "WARNING: npm audit found high-severity vulnerabilities"
        fi
    elif [[ -f "requirements.txt" ]] && command -v safety > /dev/null 2>&1; then
        log "Running Python security check..."
        if ! safety check > /dev/null 2>&1; then
            log "WARNING: Python security vulnerabilities detected"
        fi
    elif [[ -f "Cargo.toml" ]] && command -v cargo-audit > /dev/null 2>&1; then
        log "Running Rust security audit..."
        if ! cargo audit > /dev/null 2>&1; then
            log "WARNING: Rust security vulnerabilities detected"
        fi
    fi
    
    return 0
}

# Main execution
main() {
    log "Starting pre-tool-use validation checks..."
    
    # Check git repository status
    if check_git_repo; then
        check_uncommitted_changes
    fi
    
    # Check tests (fail if tests are failing)
    if ! check_tests; then
        log "BLOCKING: Tests must pass before tool use"
        exit 1
    fi
    
    # Check code quality (warning only)
    check_code_quality
    
    # Check security (warning only)
    check_security
    
    log "Pre-tool-use checks completed successfully"
    return 0
}

# Run main function
main "$@"