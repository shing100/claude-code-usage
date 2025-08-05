#!/bin/bash

echo "🎨 Running format and lint checks..."

# Check if package.json exists (Node.js project)
if [ -f "package.json" ]; then
    echo "📦 Node.js project detected"
    
    # Run prettier if available
    if npm list prettier --depth=0 >/dev/null 2>&1; then
        echo "✨ Running Prettier..."
        npx prettier --write .
    fi
    
    # Run ESLint if available
    if npm list eslint --depth=0 >/dev/null 2>&1; then
        echo "🔍 Running ESLint..."
        npx eslint . --fix --quiet
    fi
fi

# Check if pyproject.toml exists (Python project with uv)
if [ -f "pyproject.toml" ]; then
    echo "🐍 Python project detected"
    
    # Run ruff format
    if command -v uvx >/dev/null 2>&1; then
        echo "✨ Running ruff format..."
        uvx ruff format .
        
        echo "🔍 Running ruff check..."
        uvx ruff check . --fix
    elif command -v ruff >/dev/null 2>&1; then
        echo "✨ Running ruff format..."
        ruff format .
        
        echo "🔍 Running ruff check..."
        ruff check . --fix
    fi
fi

# Check if Cargo.toml exists (Rust project)
if [ -f "Cargo.toml" ]; then
    echo "🦀 Rust project detected"
    
    echo "✨ Running rustfmt..."
    cargo fmt
    
    echo "🔍 Running clippy..."
    cargo clippy --fix --allow-dirty --allow-staged
fi

echo "✅ Format and lint checks completed!"
exit 0