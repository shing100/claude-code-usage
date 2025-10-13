# CLAUDE.md - Workflow Examples Project

This file provides guidance to Claude Code when working with workflow examples and patterns.

## Project Overview

This repository demonstrates real-world Claude Code workflows for feature development, bug fixing, and code refactoring. It serves as a comprehensive reference for development teams adopting Claude Code.

## Repository Purpose

**Primary Goal:** Provide production-ready workflow templates that teams can adopt and customize for their specific needs.

**Key Features:**
- Step-by-step workflow documentation
- Real-world examples and use cases
- Best practices and patterns
- Integration with CI/CD systems
- Customization guidelines

## Workflow Categories

### 1. Feature Development Workflow
**File:** `.claude/workflows/feature-development.md`

**Use When:**
- Building new features from scratch
- Implementing user stories
- Adding new functionality to existing systems
- Creating new API endpoints or UI components

**Key Stages:**
1. Planning & Specification → Define requirements
2. Backend Implementation → Build server-side logic
3. Frontend Implementation → Create user interfaces
4. Testing → Comprehensive validation
5. Security Review → Vulnerability assessment
6. Code Review → Quality assurance
7. Documentation → Technical writing
8. Deployment → Staged rollout

### 2. Bug Fixing Workflow
**File:** `.claude/workflows/bug-fixing.md`

**Use When:**
- Resolving production issues
- Fixing reported bugs
- Addressing edge cases
- Correcting unexpected behavior

**Key Stages:**
1. Triage → Assess severity and impact
2. Reproduce → Create reliable reproduction
3. Diagnose → Root cause analysis
4. Fix (TDD) → Write test, implement solution
5. Validate → Comprehensive testing
6. Deploy → Controlled rollout
7. Verify → Production validation

### 3. Code Refactoring Workflow
**File:** `.claude/workflows/refactoring.md`

**Use When:**
- Reducing technical debt
- Improving code maintainability
- Optimizing performance
- Modernizing legacy code
- Reducing complexity

**Key Stages:**
1. Assessment → Identify issues
2. Planning → Create refactoring strategy
3. Test Safety Net → Ensure adequate coverage
4. Incremental Changes → Small, testable improvements
5. Performance Validation → Benchmark impact
6. Review → Quality verification
7. Documentation → Update architecture docs

## Command Reference

### Workflow Management
```bash
# Execute complete workflows
/workflow feature "feature-name"
/workflow bugfix "bug-description"
/workflow refactor "component-name"

# Workflow control
/workflow status              # Check current progress
/workflow pause               # Pause execution
/workflow resume              # Resume paused workflow
/workflow cancel              # Cancel workflow
```

### Stage-Specific Commands
```bash
# Planning
/plan-feature "feature-name"
/analyze-bug [bug-id]

# Implementation
/backend "implement API endpoints"
/frontend "create UI components"

# Testing
/test-suite all --coverage
/create-test "test description"

# Quality Assurance
/code-review --focus security
/security-audit "component-name"
/refactor extract-method "method-name"

# Deployment
/deploy-staging branch-name
/deploy-production branch-name
```

## Development Standards

### Code Quality Requirements
- **Test Coverage:** Minimum 80% line coverage, 70% branch coverage
- **Complexity:** Cyclomatic complexity < 10 per function
- **Duplication:** Code duplication < 3%
- **Documentation:** All public APIs documented
- **Security:** No high-severity vulnerabilities

### Testing Strategy
- **Unit Tests:** Test individual functions and methods
- **Integration Tests:** Test component interactions
- **E2E Tests:** Test complete user workflows
- **Performance Tests:** Validate response times
- **Security Tests:** Verify security controls

### Commit Conventions
```bash
# Feature commits
git commit -m "feat: add OAuth authentication"

# Bug fixes
git commit -m "fix: resolve email validation error"

# Refactoring
git commit -m "refactor: extract validation service"

# Documentation
git commit -m "docs: update API documentation"

# Tests
git commit -m "test: add email validation tests"
```

## Workflow Patterns

### Pattern 1: Test-Driven Development
```
1. Write failing test
2. Implement minimal code to pass
3. Refactor for quality
4. Repeat
```

**Commands:**
```bash
/create-test "feature description"
npm test -- --watch
/backend "implement feature"
/refactor "improve code quality"
```

### Pattern 2: Incremental Refactoring
```
1. Assess code quality
2. Make small change
3. Run tests
4. Commit
5. Repeat
```

**Commands:**
```bash
/analyze-code-quality "file-path"
/refactor extract-method "method-name"
npm test
git commit -m "refactor: extract method"
```

### Pattern 3: Feature Branch Workflow
```
1. Create feature branch
2. Implement incrementally
3. Commit frequently
4. Open PR when ready
5. Deploy after review
```

**Commands:**
```bash
git checkout -b feature/oauth-auth
/workflow feature "OAuth authentication"
git push -u origin feature/oauth-auth
/create-pr "Add OAuth authentication"
```

## Project-Specific Customization

### Adding Custom Workflows
Create new workflow files in `.claude/workflows/custom/`:

```markdown
# my-workflow.md
# Custom Workflow Name

## Purpose
What this workflow accomplishes

## Prerequisites
Required setup and tools

## Steps
1. Step one
2. Step two
...

## Expected Outcomes
Success criteria
```

### Modifying Existing Workflows
To adapt workflows for your project:
1. Copy workflow file
2. Adjust stages to match your process
3. Update commands to use your tools
4. Test thoroughly in development
5. Document changes

### Project-Specific Commands
Add custom commands in `.claude/commands/`:
- Project-specific validation
- Custom deployment scripts
- Specialized testing commands
- Domain-specific workflows

## Integration Points

### CI/CD Integration
```yaml
# GitHub Actions
name: Workflow Validation
on: [push, pull_request]
jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - name: Run workflow
        run: /workflow validate
```

### Git Hooks
```bash
# Pre-commit validation
#!/bin/bash
/workflow validate-commit

# Pre-push testing
#!/bin/bash
npm test
```

### Issue Tracking
Link workflows to issues:
```bash
# Start workflow for issue
/workflow bugfix "Fix #123 - email validation"

# Reference in commits
git commit -m "fix: resolve email validation (#123)"
```

## Best Practices

### Workflow Execution
1. **Read workflow documentation first** - Understand stages before starting
2. **Don't skip critical stages** - Testing and security are essential
3. **Monitor progress** - Use `/workflow status` regularly
4. **Commit frequently** - Small commits are easier to review
5. **Document decisions** - Record important choices

### Quality Assurance
1. **Test before committing** - Ensure all tests pass
2. **Review your own code** - Self-review before PR
3. **Validate security** - Run security scans
4. **Check performance** - Benchmark critical paths
5. **Update documentation** - Keep docs in sync

### Team Collaboration
1. **Share workflow results** - Communicate progress
2. **Document blockers** - Identify impediments early
3. **Request reviews promptly** - Don't delay PR creation
4. **Respond to feedback** - Address review comments quickly
5. **Learn from metrics** - Improve based on data

## Troubleshooting

### Common Issues

**Workflow Stuck:**
```bash
/workflow status           # Check current state
/workflow logs            # View detailed logs
/workflow skip-stage      # Skip stage (use carefully)
```

**Test Failures:**
```bash
npm test -- --verbose     # Detailed test output
/diagnose "test failure"  # Analyze root cause
/create-test "edge case"  # Add missing test
```

**Deployment Issues:**
```bash
/workflow rollback        # Rollback deployment
/monitor-metrics          # Check system health
/verify-fix               # Validate resolution
```

### Getting Help

1. **Check workflow documentation** - See specific workflow file
2. **Review examples** - Look at example implementations
3. **Check logs** - Use `/workflow logs` for details
4. **Consult README** - Main documentation in README.md
5. **Community support** - GitHub issues and discussions

## Performance Metrics

Track workflow efficiency:

```bash
/workflow metrics         # View performance data
```

**Target Metrics:**
- Feature Development: < 5 days
- Bug Fixing: < 4 hours
- Code Refactoring: < 8 hours
- Code Review: < 1 hour

## Security Considerations

**Always:**
- Run security audits before deployment
- Validate input at all boundaries
- Use parameterized queries
- Implement proper authentication
- Log security events
- Encrypt sensitive data

**Never:**
- Skip security review for "quick fixes"
- Commit secrets or credentials
- Disable security checks
- Deploy without testing
- Ignore security warnings

## Version Control

### Branching Strategy
- `main` - Production-ready code
- `develop` - Integration branch
- `feature/*` - New features
- `bugfix/*` - Bug fixes
- `refactor/*` - Code improvements

### PR Requirements
- [ ] All tests passing
- [ ] Code review approved
- [ ] Documentation updated
- [ ] Security scan passed
- [ ] Performance validated
- [ ] No merge conflicts

## Continuous Improvement

**Regular Reviews:**
- Weekly: Review workflow metrics
- Monthly: Assess workflow effectiveness
- Quarterly: Update workflows based on learnings

**Feedback Loop:**
1. Collect metrics after each workflow
2. Identify bottlenecks and issues
3. Propose improvements
4. Test changes in development
5. Roll out to team

## Resources

### Internal Documentation
- Workflow files in `.claude/workflows/`
- Command reference in `.claude/commands/`
- Examples in `examples/` directory

### External Resources
- [Claude Code Docs](https://docs.anthropic.com/en/docs/claude-code)
- [Workflow Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)
- [Community Examples](https://github.com/hesreallyhim/awesome-claude-code)

---

## Quick Reference

### Most Common Commands
```bash
/workflow feature "name"       # Start feature development
/workflow bugfix "issue"       # Fix bug systematically
/workflow refactor "code"      # Improve code quality
/test-suite all --coverage    # Run comprehensive tests
/code-review --focus all      # Complete code review
/deploy-staging branch        # Deploy to staging
```

### Workflow Stages
Feature: Plan → Backend → Frontend → Test → Security → Review → Docs → Deploy  
Bugfix: Triage → Reproduce → Diagnose → Fix → Test → Deploy → Verify  
Refactor: Assess → Plan → Test → Refactor → Validate → Review → Document