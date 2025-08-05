#!/bin/bash

echo "🚀 Running comprehensive project checks..."

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Track if any checks failed
FAILED=0

# Frontend checks (Node.js/TypeScript)
if [ -f "package.json" ]; then
    echo "📦 Checking frontend (Node.js) project..."
    
    # Install dependencies if node_modules doesn't exist
    if [ ! -d "node_modules" ]; then
        echo "📥 Installing dependencies..."
        npm install
    fi
    
    # TypeScript type checking
    if command_exists "tsc" || npm list typescript --depth=0 >/dev/null 2>&1; then
        echo "🔍 Running TypeScript type check..."
        if ! npx tsc --noEmit; then
            echo "❌ TypeScript type check failed"
            FAILED=1
        else
            echo "✅ TypeScript type check passed"
        fi
    fi
    
    # ESLint
    if npm list eslint --depth=0 >/dev/null 2>&1; then
        echo "🔍 Running ESLint..."
        if ! npx eslint . --quiet; then
            echo "❌ ESLint check failed"
            FAILED=1
        else
            echo "✅ ESLint check passed"
        fi
    fi
    
    # Prettier
    if npm list prettier --depth=0 >/dev/null 2>&1; then
        echo "✨ Running Prettier..."
        npx prettier --write .
        echo "✅ Code formatted with Prettier"
    fi
    
    # Jest tests
    if npm list jest --depth=0 >/dev/null 2>&1; then
        echo "🧪 Running Jest tests..."
        if ! npm test -- --passWithNoTests --silent; then
            echo "❌ Jest tests failed" 
            FAILED=1
        else
            echo "✅ Jest tests passed"
        fi
    fi
    
    # Vitest tests
    if npm list vitest --depth=0 >/dev/null 2>&1; then
        echo "🧪 Running Vitest tests..."
        if ! npx vitest run --silent; then
            echo "❌ Vitest tests failed"
            FAILED=1
        else
            echo "✅ Vitest tests passed"
        fi
    fi
fi

# Backend checks (Python)
if [ -f "pyproject.toml" ] || [ -f "requirements.txt" ]; then
    echo "🐍 Checking Python backend project..."
    
    # Ruff formatting and linting
    if command_exists "uvx"; then
        echo "✨ Running ruff format..."
        uvx ruff format .
        
        echo "🔍 Running ruff check..."
        if ! uvx ruff check .; then
            echo "❌ Ruff check failed"
            FAILED=1
        else
            echo "✅ Ruff check passed"
        fi
        
        # MyPy type checking
        echo "🔍 Running MyPy type check..."
        if ! uvx mypy . --ignore-missing-imports; then
            echo "❌ MyPy type check failed"
            FAILED=1
        else
            echo "✅ MyPy type check passed"
        fi
        
        # Pytest
        echo "🧪 Running Python tests..."
        if ! uvx pytest -v --tb=short; then
            echo "❌ Python tests failed"
            FAILED=1
        else
            echo "✅ Python tests passed"
        fi
    elif command_exists "ruff"; then
        echo "✨ Running ruff format..."
        ruff format .
        
        echo "🔍 Running ruff check..."
        if ! ruff check .; then
            echo "❌ Ruff check failed"
            FAILED=1
        else
            echo "✅ Ruff check passed"
        fi
    fi
fi

# Rust checks
if [ -f "Cargo.toml" ]; then
    echo "🦀 Checking Rust project..."
    
    echo "✨ Running rustfmt..."
    cargo fmt
    
    echo "🔍 Running clippy..."
    if ! cargo clippy -- -D warnings; then
        echo "❌ Clippy check failed"
        FAILED=1
    else
        echo "✅ Clippy check passed"
    fi
    
    echo "🧪 Running Rust tests..."
    if ! cargo test; then
        echo "❌ Rust tests failed"
        FAILED=1
    else
        echo "✅ Rust tests passed"
    fi
fi

# Docker checks
if [ -f "Dockerfile" ]; then
    echo "🐳 Checking Docker configuration..."
    
    if command_exists "docker"; then
        echo "🔍 Validating Dockerfile..."
        if ! docker build -t temp-check .; then
            echo "❌ Docker build failed"
            FAILED=1
        else
            echo "✅ Docker build successful"
            docker rmi temp-check >/dev/null 2>&1
        fi
    fi
fi

# Security checks
if [ -f "package.json" ]; then
    echo "🔒 Running security audit..."
    if ! npm audit --audit-level moderate; then
        echo "⚠️  Security vulnerabilities found - please review"
    else
        echo "✅ Security audit passed"
    fi
fi

# Final result
if [ $FAILED -eq 0 ]; then
    echo "🎉 All checks passed successfully!"
    exit 0
else
    echo "💥 Some checks failed. Please review and fix the issues above."
    exit 1
fi