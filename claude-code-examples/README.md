# Claude Code Configuration Examples

This directory contains comprehensive examples of Claude Code configurations for different project types and use cases.

## Directory Structure

```
claude-code-examples/
├── basic-project/               # Simple web application setup
│   └── .claude/
│       ├── settings.json        # Basic configuration
│       └── hooks/
│           └── format-and-lint.sh
├── advanced-project/            # Complex fullstack project
│   └── .claude/
│       ├── settings.json        # Advanced config with subagents
│       └── hooks/
│           └── comprehensive-check.sh
└── microservices-project/       # Distributed systems setup
    └── .claude/
        ├── settings.json        # Microservices-specific config
        └── hooks/
            ├── microservice-validation.sh
            └── pre-commit-checks.sh
```

## Example Configurations

### 1. Basic Project (`basic-project/`)
- **Use Case**: Simple web applications, small teams
- **Features**: 
  - Basic permissions and hooks
  - Automatic formatting and linting
  - Simple error checking
- **Languages**: JavaScript/TypeScript, Python, Rust
- **Hook Scripts**: format-and-lint.sh

### 2. Advanced Project (`advanced-project/`)
- **Use Case**: Complex fullstack applications, larger teams
- **Features**:
  - Specialized subagents (backend, frontend, devops)
  - Comprehensive pre/post-tool hooks
  - Multi-language support with extensive validation
  - Security audits and type checking
- **Languages**: All major languages with advanced tooling
- **Hook Scripts**: comprehensive-check.sh

### 3. Microservices Project (`microservices-project/`)
- **Use Case**: Distributed systems, container orchestration
- **Features**:
  - Microservices-specific agents
  - Kubernetes and Docker validation
  - Service mesh and API gateway configuration
  - Comprehensive container and security checks
- **Technologies**: Docker, Kubernetes, service mesh
- **Hook Scripts**: microservice-validation.sh, pre-commit-checks.sh

## Hook Scripts Explained

### format-and-lint.sh (Basic)
- Detects project type (Node.js, Python, Rust)
- Runs appropriate formatters (Prettier, ruff, rustfmt)
- Applies linting fixes (ESLint, ruff, clippy)

### comprehensive-check.sh (Advanced)  
- Multi-language type checking and testing
- Security audits
- Performance validation
- Docker build verification
- Complete CI/CD pipeline simulation

### microservice-validation.sh (Microservices)
- Dockerfile and Kubernetes manifest validation
- Service discovery and API gateway checks
- Health check endpoint verification
- Observability configuration validation
- Security and resource limit checks

## Usage

1. **Copy Configuration**: Copy the appropriate example to your project
2. **Customize Settings**: Modify settings.json for your specific needs
3. **Update Hooks**: Adapt hook scripts to your project requirements
4. **Set Permissions**: Make hook scripts executable with `chmod +x`

## Configuration Hierarchy

Settings are applied in this order of precedence:
1. Enterprise/Organization policies
2. User settings (`~/.claude/settings.json`)
3. Project settings (`.claude/settings.json`)
4. Local overrides (`.claude/settings.local.json`)

## Best Practices

1. **Start Simple**: Begin with basic-project configuration
2. **Iterate Gradually**: Add complexity as your project grows
3. **Test Hooks**: Verify hook scripts work in your environment
4. **Document Changes**: Keep README updated with configuration changes
5. **Security First**: Never commit sensitive information in settings files
6. **Version Control**: Commit .claude/settings.json, ignore settings.local.json

## Further Reading

See `CLAUDE_CODE_COMPLETE_GUIDE.md` in the parent directory for comprehensive documentation on Claude Code usage patterns, advanced features, and integration strategies.