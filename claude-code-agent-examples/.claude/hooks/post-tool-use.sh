#!/bin/bash

# Post-tool-use hook for Claude Code
# This script runs after any tool is used by Claude
# Use this to format code, run tests, update documentation, or perform cleanup

set -euo pipefail

# Configuration
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
LOG_FILE="${REPO_ROOT}/.claude/logs/post-tool-use.log"

# Ensure log directory exists
mkdir -p "$(dirname "$LOG_FILE")"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

log "Post-tool-use hook starting..."

# Function to auto-format code
format_code() {
    local formatted=false
    
    # JavaScript/TypeScript formatting
    if [[ -f "package.json" ]]; then
        if jq -e '.scripts.format' package.json > /dev/null 2>&1; then
            log "Running npm format script..."
            npm run format > /dev/null 2>&1 && formatted=true
        elif command -v prettier > /dev/null 2>&1; then
            log "Running prettier..."
            prettier --write "**/*.{js,jsx,ts,tsx,json,css,md}" > /dev/null 2>&1 && formatted=true
        fi
    fi
    
    # Python formatting
    if [[ -f "pyproject.toml" ]] || [[ -f "requirements.txt" ]] || [[ -f "setup.py" ]]; then
        if command -v ruff > /dev/null 2>&1; then
            log "Running ruff format..."
            ruff format . > /dev/null 2>&1 && formatted=true
        elif command -v black > /dev/null 2>&1; then
            log "Running black..."
            black . > /dev/null 2>&1 && formatted=true
        fi
        
        # Import sorting
        if command -v ruff > /dev/null 2>&1; then
            log "Running ruff import sorting..."
            ruff check --select I --fix . > /dev/null 2>&1
        elif command -v isort > /dev/null 2>&1; then
            log "Running isort..."
            isort . > /dev/null 2>&1
        fi
    fi
    
    # Rust formatting
    if [[ -f "Cargo.toml" ]]; then
        log "Running cargo fmt..."
        cargo fmt > /dev/null 2>&1 && formatted=true
    fi
    
    # Go formatting
    if [[ -f "go.mod" ]]; then
        log "Running gofmt..."
        gofmt -w . > /dev/null 2>&1 && formatted=true
        if command -v goimports > /dev/null 2>&1; then
            log "Running goimports..."
            goimports -w . > /dev/null 2>&1
        fi
    fi
    
    # Generic Makefile formatting
    if [[ -f "Makefile" ]] && grep -q "^format:" Makefile; then
        log "Running make format..."
        make format > /dev/null 2>&1 && formatted=true
    fi
    
    if [[ "$formatted" == true ]]; then
        log "Code formatting completed"
    else
        log "No formatting tools found or configured"
    fi
}

# Function to run quick tests
run_quick_tests() {
    local test_command=""
    
    # Detect test command based on project type
    if [[ -f "package.json" ]]; then
        if jq -e '.scripts."test:quick"' package.json > /dev/null 2>&1; then
            test_command="npm run test:quick"
        elif jq -e '.scripts.test' package.json > /dev/null 2>&1; then
            test_command="npm test -- --passWithNoTests --watchAll=false"
        fi
    elif [[ -f "pyproject.toml" ]] || [[ -f "requirements.txt" ]]; then
        if command -v pytest > /dev/null 2>&1; then
            test_command="pytest --tb=short -x -q"
        fi
    elif [[ -f "Cargo.toml" ]]; then
        test_command="cargo test --quiet"
    elif [[ -f "go.mod" ]]; then
        test_command="go test ./... -short -v"
    elif [[ -f "Makefile" ]] && grep -q "^test-quick:" Makefile; then
        test_command="make test-quick"
    fi
    
    if [[ -n "$test_command" ]]; then
        log "Running quick tests: $test_command"
        if eval "$test_command" > /dev/null 2>&1; then
            log "Quick tests passed"
        else
            log "WARNING: Quick tests failed - full test suite may be needed"
        fi
    else
        log "No quick test command configured"
    fi
}

# Function to update documentation
update_documentation() {
    # Generate API documentation if tools are available
    if [[ -f "package.json" ]] && command -v jsdoc > /dev/null 2>&1; then
        if [[ -f "jsdoc.json" ]] || jq -e '.scripts.docs' package.json > /dev/null 2>&1; then
            log "Updating JavaScript documentation..."
            npm run docs > /dev/null 2>&1 || jsdoc -c jsdoc.json > /dev/null 2>&1
        fi
    fi
    
    # Python documentation
    if command -v sphinx-build > /dev/null 2>&1 && [[ -d "docs" ]]; then
        log "Building Sphinx documentation..."
        sphinx-build -b html docs docs/_build/html > /dev/null 2>&1
    fi
    
    # Rust documentation
    if [[ -f "Cargo.toml" ]]; then
        log "Generating Rust documentation..."
        cargo doc --no-deps > /dev/null 2>&1
    fi
    
    # Go documentation
    if [[ -f "go.mod" ]] && command -v godoc > /dev/null 2>&1; then
        log "Go documentation available via godoc"
    fi
}

# Function to check for and stage formatting changes
stage_formatting_changes() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        # Check if there are any changes from formatting
        if ! git diff --quiet; then
            log "Formatting changes detected"
            
            # Stage only formatting-related files (be conservative)
            # This stages common file types that are likely formatting changes
            git add -A "*.py" "*.js" "*.jsx" "*.ts" "*.tsx" "*.rs" "*.go" "*.json" "*.yml" "*.yaml" > /dev/null 2>&1 || true
            
            log "Staging formatting changes"
        fi
    fi
}

# Function to run linting and auto-fix
lint_and_fix() {
    # JavaScript/TypeScript linting
    if [[ -f "package.json" ]]; then
        if jq -e '.scripts."lint:fix"' package.json > /dev/null 2>&1; then
            log "Running lint:fix..."
            npm run lint:fix > /dev/null 2>&1
        elif command -v eslint > /dev/null 2>&1; then
            log "Running eslint --fix..."
            eslint --fix . > /dev/null 2>&1 || true
        fi
    fi
    
    # Python linting
    if command -v ruff > /dev/null 2>&1; then
        log "Running ruff auto-fix..."
        ruff check --fix . > /dev/null 2>&1 || true
    fi
    
    # Go linting
    if [[ -f "go.mod" ]] && command -v golangci-lint > /dev/null 2>&1; then
        log "Running golangci-lint..."
        golangci-lint run --fix > /dev/null 2>&1 || true
    fi
}

# Function to generate or update lock files
update_lock_files() {
    # Node.js
    if [[ -f "package.json" ]] && [[ ! -f "package-lock.json" ]] && [[ ! -f "yarn.lock" ]]; then
        log "Generating package-lock.json..."
        npm install --package-lock-only > /dev/null 2>&1
    fi
    
    # Python with Poetry
    if [[ -f "pyproject.toml" ]] && command -v poetry > /dev/null 2>&1; then
        if ! [[ -f "poetry.lock" ]]; then
            log "Generating poetry.lock..."
            poetry lock --no-update > /dev/null 2>&1
        fi
    fi
    
    # Rust
    if [[ -f "Cargo.toml" ]] && [[ ! -f "Cargo.lock" ]]; then
        log "Generating Cargo.lock..."
        cargo generate-lockfile > /dev/null 2>&1
    fi
}

# Function to cleanup temporary files
cleanup_temp_files() {
    # Remove common temporary files
    find . -name "*.pyc" -delete 2>/dev/null || true
    find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
    find . -name ".DS_Store" -delete 2>/dev/null || true
    find . -name "Thumbs.db" -delete 2>/dev/null || true
    find . -name "*.tmp" -delete 2>/dev/null || true
    
    # Remove empty directories (be careful)
    find . -type d -empty -not -path "./.git/*" -delete 2>/dev/null || true
    
    log "Cleaned up temporary files"
}

# Function to update gitignore if needed
update_gitignore() {
    if [[ -f ".gitignore" ]]; then
        # Add common entries if they don't exist
        local entries=(
            "*.pyc"
            "__pycache__/"
            ".DS_Store"
            "Thumbs.db"
            "*.log"
            ".env"
            "node_modules/"
            ".coverage"
            "*.tmp"
        )
        
        for entry in "${entries[@]}"; do
            if ! grep -q "^${entry}$" .gitignore; then
                echo "$entry" >> .gitignore
            fi
        done
    fi
}

# Main execution
main() {
    log "Starting post-tool-use processing..."
    
    # Core post-processing steps
    format_code
    lint_and_fix
    
    # Stage any formatting changes
    stage_formatting_changes
    
    # Optional steps (less critical)
    run_quick_tests
    update_lock_files
    cleanup_temp_files
    update_gitignore
    update_documentation
    
    log "Post-tool-use processing completed"
    return 0
}

# Run main function
main "$@"