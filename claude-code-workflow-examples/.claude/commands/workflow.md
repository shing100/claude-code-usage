# Workflow Command

Execute predefined development workflows for common tasks.

## Usage
```
/workflow [workflow-name] [options]
```

## Available Workflows

### 1. Feature Development
```bash
/workflow feature "user authentication"
```

**Stages:**
1. Planning & specification
2. Backend implementation
3. Frontend implementation
4. Testing
5. Security review
6. Code review
7. Documentation
8. Deployment

**Options:**
- `--skip-stage [stage-name]` - Skip specific stage
- `--start-from [stage-name]` - Start from specific stage
- `--dry-run` - Simulate workflow without changes

**Example:**
```bash
# Full workflow
/workflow feature "OAuth integration"

# Start from testing stage
/workflow feature "OAuth integration" --start-from testing

# Skip documentation stage
/workflow feature "OAuth integration" --skip-stage documentation
```

---

### 2. Bug Fixing
```bash
/workflow bugfix "email validation error"
```

**Stages:**
1. Bug report & triage
2. Reproduction
3. Root cause diagnosis
4. Test-driven fix
5. Testing & validation
6. Code review
7. Deployment
8. Verification

**Options:**
- `--severity [critical|high|medium|low]` - Set bug severity
- `--environment [staging|production]` - Target environment

**Example:**
```bash
# Critical bug fix
/workflow bugfix "payment processing failure" --severity critical

# Staging environment bug
/workflow bugfix "search results issue" --environment staging
```

---

### 3. Refactoring
```bash
/workflow refactor "user-service"
```

**Stages:**
1. Code quality assessment
2. Refactoring plan creation
3. Test coverage establishment
4. Incremental refactoring
5. Performance validation
6. Code review
7. Documentation update

**Options:**
- `--focus [complexity|duplication|naming]` - Focus area
- `--aggressive` - More extensive refactoring

**Example:**
```bash
# Focus on complexity reduction
/workflow refactor "order-processing" --focus complexity

# Comprehensive refactoring
/workflow refactor "legacy-module" --aggressive
```

---

### 4. Code Review
```bash
/workflow review [target]
```

**Review Areas:**
- Code quality and style
- Security vulnerabilities
- Performance issues
- Test coverage
- Documentation

**Options:**
- `--depth [quick|standard|comprehensive]` - Review depth
- `--focus [security|performance|maintainability]` - Focus area

**Example:**
```bash
# Quick review of recent changes
/workflow review --depth quick

# Security-focused review
/workflow review auth-module --focus security

# Comprehensive review
/workflow review --depth comprehensive
```

---

### 5. Release Preparation
```bash
/workflow release [version]
```

**Stages:**
1. Version bump
2. Changelog generation
3. Final testing
4. Security audit
5. Documentation update
6. Build artifacts
7. Create release notes

**Options:**
- `--type [major|minor|patch]` - Release type
- `--pre-release` - Mark as pre-release

**Example:**
```bash
# Patch release
/workflow release 1.2.4 --type patch

# Beta release
/workflow release 2.0.0-beta.1 --pre-release
```

---

## Workflow Configuration

### Custom Workflow Definition
Create custom workflows in `.claude/workflows/custom/`

```yaml
# .claude/workflows/custom/my-workflow.yml
name: my-custom-workflow
description: Custom workflow for specific needs

stages:
  - name: stage1
    description: First stage
    commands:
      - /analyze-code
      - /run-tests
    
  - name: stage2
    description: Second stage
    commands:
      - /deploy-staging
    depends_on: [stage1]

options:
  skip_on_error: false
  parallel: false
  timeout: 3600
```

### Workflow Hooks

**Pre-workflow hook:**
```bash
# .claude/hooks/pre-workflow.sh
#!/bin/bash
echo "Starting workflow: $WORKFLOW_NAME"
# Validation logic
```

**Post-workflow hook:**
```bash
# .claude/hooks/post-workflow.sh
#!/bin/bash
echo "Completed workflow: $WORKFLOW_NAME"
# Cleanup or notification logic
```

---

## Workflow Status & Control

### Check Status
```bash
/workflow status
```

**Output:**
```
Current Workflow: feature-oauth-integration
Status: IN_PROGRESS
Stage: 3/8 (Frontend Implementation)
Started: 2024-01-15 10:30:00
Elapsed: 1h 25m

Completed Stages:
✅ Planning & specification
✅ Backend implementation
🔄 Frontend implementation (in progress)
⏳ Testing (pending)
⏳ Security review (pending)
⏳ Code review (pending)
⏳ Documentation (pending)
⏳ Deployment (pending)
```

### Pause Workflow
```bash
/workflow pause
```

### Resume Workflow
```bash
/workflow resume
```

### Cancel Workflow
```bash
/workflow cancel
```

---

## Workflow Templates

### Template: API Development
```yaml
name: api-development
stages:
  - planning: API design & specification
  - implementation: Backend implementation
  - testing: API testing & validation
  - documentation: API documentation generation
  - deployment: Staging deployment
```

### Template: Bug Triage
```yaml
name: bug-triage
stages:
  - assessment: Severity & impact analysis
  - reproduction: Create reproduction steps
  - assignment: Assign to appropriate team
  - tracking: Add to bug tracking system
```

### Template: Security Audit
```yaml
name: security-audit
stages:
  - scanning: Automated security scanning
  - manual_review: Manual code review
  - penetration_testing: Security testing
  - report: Generate security report
  - remediation: Fix identified issues
```

---

## Best Practices

### Workflow Selection
- Use `feature` for new functionality
- Use `bugfix` for issue resolution
- Use `refactor` for code improvement
- Use `review` for quality assurance
- Use `release` for version deployment

### Stage Management
- Don't skip critical stages (testing, security)
- Use `--dry-run` to preview workflow
- Monitor progress with `/workflow status`
- Pause/resume for long-running workflows

### Custom Workflows
- Create project-specific workflows
- Version control workflow definitions
- Document custom workflow usage
- Test workflows in development first

---

## Troubleshooting

### Workflow Stuck
```bash
# Check current status
/workflow status

# View detailed logs
/workflow logs

# Force stage completion (use with caution)
/workflow skip-stage [stage-name]
```

### Workflow Failed
```bash
# View error details
/workflow errors

# Retry failed stage
/workflow retry

# Rollback to previous stage
/workflow rollback
```

### Reset Workflow
```bash
# Cancel and reset
/workflow cancel
/workflow reset
```

---

## Integration with CI/CD

### GitHub Actions Integration
```yaml
# .github/workflows/claude-workflow.yml
name: Claude Code Workflow
on: [push]

jobs:
  workflow:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run Claude workflow
        run: |
          claude workflow feature "auto-deploy" --non-interactive
```

### GitLab CI Integration
```yaml
# .gitlab-ci.yml
claude_workflow:
  script:
    - claude workflow review --depth standard
  only:
    - merge_requests
```

---

## Metrics & Reporting

### Workflow Metrics
```bash
/workflow metrics
```

**Output:**
```
Workflow Performance Metrics (Last 30 days)

Average Duration:
- Feature Development: 4h 30m
- Bug Fixing: 1h 15m
- Refactoring: 2h 45m
- Code Review: 45m

Success Rate:
- Feature Development: 95%
- Bug Fixing: 98%
- Refactoring: 92%
- Code Review: 100%

Most Time-Consuming Stages:
1. Testing (35% of total time)
2. Implementation (30% of total time)
3. Code Review (15% of total time)
```

---

## Examples

### Complete Feature Workflow
```bash
# Start feature workflow
/workflow feature "payment integration"

# Monitor progress
/workflow status

# Pause if needed
/workflow pause

# Resume
/workflow resume

# Complete
# Workflow completes automatically when all stages done
```

### Emergency Bug Fix
```bash
# Critical bug workflow with minimal stages
/workflow bugfix "critical payment error" \
  --severity critical \
  --skip-stage documentation \
  --skip-stage code-review
```

### Pre-release Checklist
```bash
# Comprehensive release workflow
/workflow release 2.0.0 \
  --type major \
  --depth comprehensive
```