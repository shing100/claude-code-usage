#!/bin/bash

echo "🔍 Running pre-commit checks for microservices..."

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

FAILED=0

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "⚠️  Not in a git repository - skipping git-based checks"
else
    # Check for large files that shouldn't be committed
    echo "📦 Checking for large files..."
    large_files=$(find . -type f -size +10M -not -path "./.git/*" -not -path "./node_modules/*" -not -path "./.claude/*")
    if [ -n "$large_files" ]; then
        echo "⚠️  Large files detected (>10MB):"
        echo "$large_files"
        echo "Consider using Git LFS for these files"
    fi
    
    # Check for sensitive information
    echo "🔒 Scanning for sensitive information..."
    sensitive_patterns=(
        "password.*="
        "secret.*="
        "api_key.*="
        "private_key"
        "BEGIN PRIVATE KEY"
        "BEGIN RSA PRIVATE KEY" 
        "client_secret"
        "auth_token"
        "access_token.*="
    )
    
    for pattern in "${sensitive_patterns[@]}"; do
        if git diff --cached --name-only | xargs grep -l -i "$pattern" 2>/dev/null; then
            echo "❌ Potential sensitive information found with pattern: $pattern"
            FAILED=1
        fi
    done
fi

# Check Docker and Kubernetes files syntax
echo "🐳 Validating container configurations..."

# Quick syntax check for Dockerfiles
for dockerfile in $(find . -name "Dockerfile*" -not -path "./node_modules/*" -not -path "./.git/*"); do
    if [ -f "$dockerfile" ]; then
        # Basic syntax validation
        if ! head -1 "$dockerfile" | grep -q "^FROM"; then
            echo "❌ $dockerfile: First instruction should be FROM"
            FAILED=1
        fi
    fi
done

# Quick syntax check for YAML files
echo "📋 Validating YAML syntax..."
for yaml_file in $(find . -name "*.yaml" -o -name "*.yml" -not -path "./node_modules/*" -not -path "./.git/*"); do
    if [ -f "$yaml_file" ]; then
        # Basic YAML syntax check using Python
        if command_exists "python3"; then
            if ! python3 -c "import yaml; yaml.safe_load(open('$yaml_file'))" 2>/dev/null; then
                echo "❌ $yaml_file: Invalid YAML syntax"
                FAILED=1
            fi
        elif command_exists "python"; then
            if ! python -c "import yaml; yaml.safe_load(open('$yaml_file'))" 2>/dev/null; then
                echo "❌ $yaml_file: Invalid YAML syntax"  
                FAILED=1
            fi
        fi
    fi
done

# Check for required files in microservices
echo "📁 Checking microservice structure..."

# Find potential service directories
service_dirs=$(find . -maxdepth 3 -type d -name "*service*" -o -name "*api*" | grep -v node_modules | grep -v .git)

for service_dir in $service_dirs; do
    if [ -d "$service_dir" ]; then
        service_name=$(basename "$service_dir")
        echo "🔍 Checking $service_name structure..."
        
        # Check for Dockerfile
        if [ ! -f "$service_dir/Dockerfile" ]; then
            echo "⚠️  $service_name: Missing Dockerfile"
        fi
        
        # Check for package.json or pyproject.toml or go.mod
        if [ ! -f "$service_dir/package.json" ] && [ ! -f "$service_dir/pyproject.toml" ] && [ ! -f "$service_dir/go.mod" ] && [ ! -f "$service_dir/Cargo.toml" ]; then
            echo "⚠️  $service_name: Missing dependency management file (package.json, pyproject.toml, go.mod, or Cargo.toml)"
        fi
    fi
done

# Check environment-specific configurations
echo "🌍 Checking environment configurations..."

env_files=(".env" ".env.example" ".env.local" ".env.development" ".env.production")
for env_file in "${env_files[@]}"; do
    if [ -f "$env_file" ]; then
        # Check for unset variables in .env files
        if grep -q "=\s*$" "$env_file"; then
            echo "⚠️  $env_file contains empty environment variables"
        fi
    fi
done

# Check for API documentation
echo "📚 Checking API documentation..."
if [ ! -f "README.md" ] && [ ! -f "docs/README.md" ] && [ ! -f "API.md" ]; then
    echo "⚠️  No README or API documentation found"
fi

# Check for monitoring and observability
echo "📊 Checking observability setup..."
observability_indicators=(
    "health"
    "metrics"
    "prometheus"
    "grafana"
    "jaeger"
    "zipkin"
    "logging"
)

found_observability=false
for indicator in "${observability_indicators[@]}"; do
    if find . -name "*$indicator*" -not -path "./node_modules/*" -not -path "./.git/*" | head -1 >/dev/null 2>&1; then
        found_observability=true
        break
    fi
done

if [ "$found_observability" = false ]; then
    echo "⚠️  No observability configurations found - consider adding health checks, metrics, and logging"
fi

# Final result
if [ $FAILED -eq 0 ]; then
    echo "✅ Pre-commit checks passed!"
    exit 0
else
    echo "❌ Pre-commit checks failed. Please fix the issues above before committing."
    exit 1
fi