# CLAUDE.md - Project Configuration for Claude Code

This file provides guidance to Claude Code when working with this example project demonstrating various agent configurations and best practices.

## Project Overview

This is a comprehensive collection of Claude Code agent examples, custom commands, and automation hooks designed to showcase modern development workflows and AI-assisted coding patterns.

## Repository Structure

```
claude-code-agent-examples/
├── .claude/
│   ├── agents/              # Specialized AI agent configurations
│   │   ├── frontend-developer.md
│   │   ├── backend-developer.md
│   │   ├── qa-engineer.md
│   │   ├── security-auditor.md
│   │   ├── devops-engineer.md
│   │   ├── data-scientist.md
│   │   ├── python-expert.md
│   │   └── documentation-writer.md
│   ├── commands/            # Custom slash commands
│   │   ├── code-review.md
│   │   ├── test-suite.md
│   │   ├── deploy-staging.md
│   │   └── api-docs.md
│   └── hooks/              # Workflow automation scripts
│       ├── pre-tool-use.sh
│       ├── post-tool-use.sh
│       └── user-prompt-submit.sh
├── examples/               # Implementation examples
└── README.md              # Main documentation
```

## Development Philosophy

### Agent-First Approach
- Use specialized agents for domain-specific tasks
- Leverage agent expertise for optimal code quality
- Combine multiple agents for complex workflows
- Maintain clear separation of concerns

### Quality Standards
- **Security**: Security-first development with regular audits
- **Testing**: Comprehensive test coverage (>80% unit, >70% integration)
- **Documentation**: Clear, up-to-date documentation for all components
- **Performance**: Response time <200ms, scalable architecture
- **Code Quality**: Clean, maintainable, well-documented code

### Automation Principles
- **Pre-tool Validation**: Ensure clean state before changes
- **Post-tool Formatting**: Automatic code formatting and quality checks
- **Continuous Testing**: Run tests after significant changes
- **Security Scanning**: Automated vulnerability detection
- **Documentation Updates**: Keep docs in sync with code changes

## Agent Usage Guidelines

### Frontend Development
```bash
# Use frontend-developer agent for UI work
/frontend-developer "Create responsive navigation component"

# Combine with testing
/qa-engineer "Test the navigation component across browsers"
```

### Backend Development
```bash
# Use backend-developer for API work
/backend-developer "Implement JWT authentication middleware"

# Add security review
/security-auditor "Review authentication implementation"
```

### Full Stack Workflows
```bash
# Use multiple agents in sequence
/backend-developer "Create user registration API"
/frontend-developer "Build registration form component"
/qa-engineer "Write integration tests for user registration"
/documentation-writer "Document the registration flow"
```

## Custom Commands

### Code Review Workflow
```bash
# Comprehensive code review
/code-review --focus security

# Performance-focused review
/code-review --focus performance
```

### Testing Workflows
```bash
# Run full test suite with coverage
/test-suite all --coverage

# Quick unit tests only
/test-suite unit --parallel
```

### Deployment Workflows
```bash
# Deploy to staging with validation
/deploy-staging feature/new-auth

# Dry run deployment
/deploy-staging --dry-run
```

### Documentation Generation
```bash
# Generate API documentation
/api-docs openapi --include-examples

# Create markdown docs
/api-docs markdown --output ./docs/
```

## Hooks Configuration

### Pre-tool-use Hook
Automatically runs before any Claude tool usage:
- ✅ Validates git repository state
- ✅ Runs test suite (blocks on failures)
- ⚠️ Checks code quality (warns on issues)
- ⚠️ Scans for security vulnerabilities

### Post-tool-use Hook
Automatically runs after any Claude tool usage:
- 🔧 Formats code automatically
- 🔧 Runs linting with auto-fix
- 🧪 Executes quick tests
- 📚 Updates documentation
- 🧹 Cleans up temporary files

### User Prompt Submit Hook
Analyzes user prompts and provides context:
- 🎯 Detects intent (security, testing, documentation, etc.)
- 🤖 Suggests relevant agents
- 📊 Gathers project context
- 🔍 Checks for security concerns

## Development Workflows

### Feature Development
1. **Planning**: Use documentation-writer for specs
2. **Backend**: Use backend-developer for API implementation
3. **Frontend**: Use frontend-developer for UI components
4. **Testing**: Use qa-engineer for comprehensive testing
5. **Security**: Use security-auditor for security review
6. **Deployment**: Use devops-engineer for deployment setup

### Bug Fixing
1. **Analysis**: Use appropriate specialist agent for investigation
2. **Testing**: Use qa-engineer to reproduce and verify fixes
3. **Security**: Use security-auditor if security-related
4. **Documentation**: Update docs if behavior changes

### Code Maintenance
1. **Review**: Use multiple agents for different perspectives
2. **Refactoring**: Use language-specific experts (python-expert, etc.)
3. **Performance**: Use appropriate agents for optimization
4. **Documentation**: Keep documentation current

## Quality Gates

### Before Committing
- [ ] All tests pass
- [ ] Code is formatted and linted
- [ ] Security scan shows no high-risk issues
- [ ] Documentation is updated
- [ ] Performance impact is acceptable

### Before Deploying
- [ ] Full test suite passes
- [ ] Security audit completed
- [ ] Performance benchmarks meet criteria
- [ ] Documentation is complete
- [ ] Rollback plan is prepared

## Tool Integration

### Testing Frameworks
- **JavaScript**: Jest, Vitest, Cypress, Playwright
- **Python**: pytest, unittest, coverage
- **Go**: built-in testing, testify
- **Rust**: built-in testing, criterion for benchmarks

### Code Quality Tools
- **JavaScript**: ESLint, Prettier, TypeScript
- **Python**: ruff, black, mypy, pylint
- **Go**: gofmt, golangci-lint, go vet
- **Rust**: rustfmt, clippy

### Security Tools
- **Dependency Scanning**: npm audit, safety, cargo audit
- **Static Analysis**: SonarQube, CodeQL, Semgrep
- **Container Security**: Trivy, Clair, Snyk

## Best Practices

### Agent Selection
- Choose the most specialized agent for the task
- Use multiple agents for complex workflows
- Leverage agent expertise for code reviews
- Combine agents for comprehensive analysis

### Command Usage
- Use custom commands for repeated workflows
- Leverage command parameters for flexibility
- Document command usage in team workflows
- Create project-specific commands as needed

### Hook Management
- Keep hooks fast and reliable
- Use hooks for automation, not manual tasks
- Test hooks in development environment
- Monitor hook performance and effectiveness

## Troubleshooting

### Common Issues
- **Hook failures**: Check hook logs in `.claude/logs/`
- **Agent conflicts**: Use specific agent selection
- **Performance issues**: Check resource usage in hooks
- **Test failures**: Review test output and fix before proceeding

### Debug Mode
Enable verbose logging by setting environment variables:
```bash
export CLAUDE_DEBUG=1
export CLAUDE_HOOK_VERBOSE=1
```

## Contributing

When adding new agents, commands, or hooks:
1. Follow existing naming conventions
2. Include comprehensive documentation
3. Add usage examples
4. Test thoroughly before committing
5. Update this CLAUDE.md file as needed

## Resources

- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [Agent Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)
- [Community Examples](https://github.com/VoltAgent/awesome-claude-code-subagents)
- [Hook Documentation](https://docs.anthropic.com/en/docs/claude-code/hooks)