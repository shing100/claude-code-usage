# Claude Code Complete Usage Guide

## Overview

Claude Code is a terminal-based AI coding assistant that integrates directly into developer workflows. This guide covers comprehensive usage patterns, folder structures, and advanced configurations based on research and practical examples.

## Table of Contents

1. [Installation & Setup](#installation--setup)
2. [Folder Structure Patterns](#folder-structure-patterns)  
3. [Configuration Examples](#configuration-examples)
4. [Advanced Features](#advanced-features)
5. [Best Practices](#best-practices)
6. [Practical Examples](#practical-examples)

## Installation & Setup

### Quick Installation
```bash
# Install Claude Code globally
npm install -g @anthropic-ai/claude-code

# Initialize in project  
claude-code init
```

### Prerequisites
- Node.js 18+
- Git repository (recommended)
- API key from Anthropic, AWS Bedrock, or Google Vertex AI

## Folder Structure Patterns

### Basic Project Structure
The minimal Claude Code setup requires a `.claude` folder in your project root:

```
project-root/
├── .claude/
│   ├── settings.json          # Main configuration
│   ├── settings.local.json    # Personal overrides (gitignored)
│   └── hooks/                 # Custom automation scripts
│       ├── format-and-lint.sh
│       └── pre-commit-check.sh
├── src/
├── tests/
└── README.md
```

### Advanced Project Structure  
For complex projects with multiple environments and specialized agents:

```
enterprise-project/
├── .claude/
│   ├── settings.json          # Team-shared settings
│   ├── settings.local.json    # Personal development settings
│   ├── settings.prod.json     # Production-specific settings
│   ├── agents/                # Custom agent definitions
│   │   ├── backend-architect.md
│   │   ├── frontend-specialist.md
│   │   └── devops-engineer.md
│   ├── hooks/                 # Automation scripts
│   │   ├── pre-commit-checks.sh
│   │   ├── comprehensive-check.sh
│   │   └── deployment-validation.sh
│   └── mcp/                   # MCP server configurations
│       ├── github.json
│       ├── monitoring.json
│       └── database.json
├── services/                  # For microservices
│   ├── auth-service/
│   ├── user-service/
│   └── notification-service/
├── frontend/
├── infrastructure/
│   ├── kubernetes/
│   ├── terraform/
│   └── docker/
└── docs/
```

### Microservices Architecture Structure
For distributed systems with multiple services:

```
microservices-project/
├── .claude/
│   ├── settings.json          # Global microservices settings
│   ├── agents/
│   │   ├── microservice-architect.md
│   │   ├── kubernetes-specialist.md
│   │   └── api-gateway-engineer.md
│   └── hooks/
│       ├── microservice-validation.sh
│       └── container-security-check.sh
├── services/
│   ├── auth-service/
│   │   ├── .claude/settings.json    # Service-specific settings
│   │   ├── Dockerfile
│   │   ├── k8s/
│   │   └── src/
│   ├── user-service/
│   └── payment-service/
├── api-gateway/
├── monitoring/
│   ├── prometheus/
│   ├── grafana/
│   └── jaeger/
└── k8s/                       # Shared Kubernetes manifests
    ├── namespaces/
    ├── ingress/
    └── monitoring/
```

## Configuration Examples

### 1. Basic Configuration (`settings.json`)

```json
{
  "permissions": {
    "allow": [
      "Bash",
      "Read", 
      "Write",
      "Edit",
      "Glob",
      "Grep"
    ]
  },
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "echo '🔍 Pre-check: Validating before modification...'",
            "timeout": 5
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/format-and-lint.sh", 
            "timeout": 30
          }
        ]
      }
    ]
  },
  "model": "claude-3-5-sonnet-20241022",
  "environment": {
    "NODE_ENV": "development",
    "PROJECT_TYPE": "fullstack"
  }
}
```

### 2. Advanced Configuration with Agents

```json
{
  "permissions": {
    "allow": [
      "Bash", "Read", "Write", "Edit", "MultiEdit", 
      "Glob", "Grep", "WebFetch", "Task"
    ]
  },
  "subagents": {
    "backend-architect": {
      "name": "Backend Architect",
      "description": "Expert in backend architecture, API design, and database optimization",
      "model": "claude-3-5-sonnet-20241022",
      "instructions": "Focus on scalable system design, API architecture, database optimization, and performance. Always consider security, maintainability, and scalability."
    },
    "frontend-specialist": {
      "name": "Frontend Specialist",
      "description": "Expert in modern frontend development with React, TypeScript, and UI/UX", 
      "model": "claude-3-5-sonnet-20241022",
      "instructions": "Focus on modern React patterns, TypeScript best practices, responsive design, accessibility, and performance optimization."
    }
  },
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "bash -c 'if [ -f \"Makefile\" ] && make -n check >/dev/null 2>&1 && ! make check >/dev/null 2>&1; then echo \"❌ Cannot modify files: make check is currently failing.\" >&2; exit 2; fi'",
            "timeout": 10
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/comprehensive-check.sh",
            "timeout": 60
          }
        ]
      }
    ]
  },
  "model": "claude-3-5-sonnet-20241022",
  "environment": {
    "NODE_ENV": "development",
    "PYTHON_ENV": "development",
    "PROJECT_TYPE": "fullstack",
    "ENABLE_DEBUG": "true"
  },
  "tools": {
    "disabled": [],
    "custom": {
      "project-stats": {
        "command": "find . -name '*.ts' -o -name '*.js' -o -name '*.py' | wc -l",
        "description": "Count total code files in project"
      }
    }
  }
}
```

### 3. Microservices Configuration

```json
{
  "permissions": {
    "allow": ["Bash", "Read", "Write", "Edit", "MultiEdit", "Glob", "Grep", "WebFetch", "Task"]
  },
  "agents": [
    {
      "name": "microservice-architect",
      "description": "Expert in microservices architecture, service mesh, API gateway design, and distributed systems patterns",
      "instructions": "Specialize in distributed systems. Focus on service decomposition, inter-service communication, data consistency patterns, circuit breakers, and observability.",
      "model": "claude-3-5-sonnet-20241022"
    },
    {
      "name": "kubernetes-specialist",
      "description": "Expert in Kubernetes, container orchestration, service mesh, and cloud-native deployment patterns", 
      "instructions": "Focus on container orchestration, service discovery, load balancing, auto-scaling, monitoring, and cloud-native deployment strategies.",
      "model": "claude-3-5-sonnet-20241022"
    }
  ],
  "mcp": {
    "servers": {
      "kubernetes": {
        "command": "kubectl-mcp-server",
        "args": ["--kubeconfig", "~/.kube/config"]
      },
      "docker-compose": {
        "command": "docker-compose-mcp-server",
        "args": ["--file", "docker-compose.yml"]
      }
    }
  }
}
```

## Advanced Features

### 1. Model Context Protocol (MCP) Integration

Claude Code supports MCP for integrating with external tools and data sources:

```json
{
  "mcp": {
    "servers": {
      "github": {
        "command": "mcp-server-github",
        "args": ["--auth-token", "${GITHUB_TOKEN}"]
      },
      "sentry": {
        "command": "mcp-server-sentry", 
        "args": ["--org", "my-org", "--auth-token", "${SENTRY_TOKEN}"]
      },
      "database": {
        "command": "mcp-server-postgres",
        "args": ["--connection-string", "${DATABASE_URL}"]
      }
    }
  }
}
```

### 2. Custom Hooks System

Hooks allow automation at different stages of tool usage:

**Pre-Tool-Use Hooks**: Run before Claude Code executes tools
- Code quality validation
- Security checks
- Environment verification

**Post-Tool-Use Hooks**: Run after Claude Code executes tools  
- Automatic formatting
- Testing
- Build validation
- Deployment checks

### 3. Specialized Agents

Agents are specialized instances of Claude optimized for specific tasks:

```markdown
---
name: backend-typescript-architect
description: Expert backend development in TypeScript with Bun runtime
color: red
---

You are a Senior Backend TypeScript Architect with deep expertise in:
- Advanced TypeScript patterns and best practices
- Bun runtime optimization and ecosystem mastery  
- RESTful API design and GraphQL implementation
- Database design, optimization, and ORM usage
- Microservices architecture and distributed systems

Your development philosophy:
- Write self-documenting code with strategic comments
- Prioritize type safety and leverage TypeScript's advanced features
- Design for maintainability, scalability, and performance
- Follow SOLID principles and clean architecture patterns
```

### 4. Environment Management

Claude Code supports hierarchical configuration:

1. **Enterprise/Organization Level**: Global policies
2. **User Level** (`~/.claude/settings.json`): Personal preferences
3. **Project Level** (`.claude/settings.json`): Team-shared settings
4. **Local Level** (`.claude/settings.local.json`): Personal project overrides

## Best Practices

### 1. Security Best Practices

```json
{
  "permissions": {
    "allow": ["Read", "Glob", "Grep"],
    "deny": ["Bash", "Write", "Edit"]
  },
  "hooks": {
    "PreToolUse": [
      {
        "matcher": ".*",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/security-scan.sh",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

### 2. Development Workflow Integration

**TDD Workflow Example**:
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command", 
            "command": "bash -c 'if ! make test >/dev/null 2>&1; then echo \"❌ Tests failing - fix before modifying code\" >&2; exit 1; fi'",
            "timeout": 30
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "make test && make format && make lint",
            "timeout": 60
          }
        ]
      }
    ]
  }
}
```

### 3. Multi-Language Project Support

```bash
#!/bin/bash
# .claude/hooks/comprehensive-check.sh

# Node.js/TypeScript
if [ -f "package.json" ]; then
    npm run type-check
    npm run lint
    npm run test
fi

# Python  
if [ -f "pyproject.toml" ]; then
    uv run ruff format .
    uv run ruff check .
    uv run mypy .
    uv run pytest
fi

# Rust
if [ -f "Cargo.toml" ]; then
    cargo fmt
    cargo clippy
    cargo test
fi

# Go
if [ -f "go.mod" ]; then
    go fmt ./...
    go vet ./...
    go test ./...
fi
```

## Practical Examples

### Example 1: Basic Web Application Setup

```bash
# Initialize project
mkdir my-web-app && cd my-web-app
git init

# Create basic Claude Code configuration
mkdir -p .claude/hooks

# Basic settings
cat > .claude/settings.json << 'EOF'
{
  "permissions": {
    "allow": ["Bash", "Read", "Write", "Edit", "Glob", "Grep"]
  },
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/format-and-lint.sh",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
EOF

# Create format hook
cat > .claude/hooks/format-and-lint.sh << 'EOF'
#!/bin/bash
if [ -f "package.json" ]; then
    npm run format 2>/dev/null || true
    npm run lint -- --fix 2>/dev/null || true
fi
EOF

chmod +x .claude/hooks/format-and-lint.sh
```

### Example 2: Microservices Project Setup

```bash
# Initialize microservices project
mkdir microservices-app && cd microservices-app
git init

# Create advanced configuration
mkdir -p .claude/{hooks,agents}

# Advanced settings with microservices agents
cat > .claude/settings.json << 'EOF'
{
  "permissions": {
    "allow": ["Bash", "Read", "Write", "Edit", "MultiEdit", "Glob", "Grep", "WebFetch", "Task"]
  },
  "agents": [
    {
      "name": "microservice-architect",
      "description": "Expert in microservices architecture and distributed systems",
      "model": "claude-3-5-sonnet-20241022"
    }
  ],
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/microservice-validation.sh",
            "timeout": 120
          }
        ]
      }
    ]
  }
}
EOF

# Create project structure
mkdir -p {services/{auth,user,payment},api-gateway,monitoring,k8s}
```

### Example 3: Python/FastAPI Project with TDD

```bash
# Initialize Python project with uv
mkdir fastapi-project && cd fastapi-project
git init

# Create Claude Code configuration for TDD workflow
mkdir -p .claude/hooks

cat > .claude/settings.json << 'EOF'
{
  "permissions": {
    "allow": ["Bash", "Read", "Write", "Edit", "Glob", "Grep"]
  },
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "bash -c 'if [ -f \"Makefile\" ] && ! make check >/dev/null 2>&1; then echo \"❌ Fix failing checks first\" >&2; exit 1; fi'",
            "timeout": 10
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "make format && make check && make test",
            "timeout": 60
          }
        ]
      }
    ]
  },
  "environment": {
    "PYTHON_ENV": "development"
  }
}
EOF

# Initialize uv project
uv init
uv add fastapi uvicorn pytest ruff mypy

# Create Makefile for TDD workflow
cat > Makefile << 'EOF'
.PHONY: format check test run

format:
	uv run ruff format .

check:
	uv run ruff check .
	uv run mypy .

test:
	uv run pytest -v

run:
	uv run uvicorn app.main:app --reload
EOF
```

## Summary

Claude Code provides powerful customization through:

1. **Hierarchical Configuration**: Enterprise → User → Project → Local settings
2. **Custom Hooks**: Automation at pre/post tool execution
3. **Specialized Agents**: Domain-specific AI assistants  
4. **MCP Integration**: Connect to external tools and data sources
5. **Multi-language Support**: Unified workflows across tech stacks

The key to effective Claude Code usage is:
- Start with basic configuration and iterate
- Use hooks for automation and quality gates
- Leverage agents for specialized tasks
- Integrate with existing development workflows
- Maintain security and best practices throughout

This comprehensive setup enables teams to maintain code quality, automate repetitive tasks, and leverage AI assistance effectively across complex, multi-service architectures.