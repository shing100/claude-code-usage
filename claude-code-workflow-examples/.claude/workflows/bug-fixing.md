# Bug Fixing Workflow

A systematic approach to identifying, diagnosing, and fixing bugs efficiently.

## Workflow Overview

```
Report → Reproduce → Diagnose → Fix → Test → Verify → Deploy
```

## 1. Bug Report & Triage

### Initial Assessment
```bash
# Analyze bug report
/analyze-bug [bug-id]
```

**Information to Gather:**
- Error messages and stack traces
- Steps to reproduce
- Expected vs actual behavior
- Environment details (OS, browser, version)
- Impact and severity
- Frequency of occurrence

**Severity Classification:**
- **Critical**: System down, data loss, security breach
- **High**: Major functionality broken, affects many users
- **Medium**: Feature partially broken, workaround available
- **Low**: Minor issue, cosmetic problem

---

## 2. Reproduce the Bug

### Create Reproduction Steps
```bash
# Attempt to reproduce
/reproduce-bug "user registration fails with email validation error"
```

**Reproduction Checklist:**
- [ ] Follow exact steps from bug report
- [ ] Test in same environment
- [ ] Capture screenshots/videos
- [ ] Document exact error messages
- [ ] Identify minimum reproduction steps
- [ ] Test in different environments

**Example Reproduction:**
```markdown
## Reproduction Steps
1. Navigate to /register
2. Enter email: "test@example.com"
3. Enter password: "ValidPass123!"
4. Click "Register" button

## Expected Result
User account created, redirect to dashboard

## Actual Result
Error: "Invalid email format"
Console shows: TypeError at validateEmail:line 45

## Environment
- Browser: Chrome 120
- OS: macOS 14.2
- Backend Version: 2.3.1
```

---

## 3. Diagnose Root Cause

### Investigation Strategy
```bash
# Deep analysis with sequential thinking
/diagnose "email validation error in registration"
```

**Diagnostic Steps:**

**1. Review Error Logs**
```bash
# Check application logs
tail -f logs/application.log | grep -i "email\|validation"

# Check error tracking service
/check-errors "registration" --timeframe "24h"
```

**2. Examine Recent Changes**
```bash
# Check git history
git log --since="1 week ago" --grep="email\|validation" --oneline

# Review recent PRs
/review-recent-changes --component "auth"
```

**3. Code Analysis**
```bash
# Analyze suspicious code
/analyze-code "src/validators/email.js"
```

**4. Identify Root Cause**
Common patterns:
- Logic errors in validation
- Race conditions
- Dependency version conflicts
- Configuration issues
- Missing error handling
- Edge case not handled

**Example Diagnosis:**
```markdown
## Root Cause Analysis

**Issue**: Email validation regex doesn't handle plus sign (+) in email addresses

**Location**: `src/validators/email.js:45`

**Code:**
```javascript
// Current (buggy) regex
const emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
```

**Problem**: Regex missing `+` character, which is valid in email addresses

**Impact**: Users with plus signs in emails (e.g., user+tag@example.com) cannot register

**Introduced**: Commit abc123 (2024-01-10) - "Tighten email validation"
```

---

## 4. Create Test Case First (TDD Approach)

### Write Failing Test
```bash
# Create test for bug
/create-test "email validation should accept plus sign"
```

**Test Example:**
```javascript
describe('Email Validation', () => {
  test('should accept email with plus sign', () => {
    const email = 'user+tag@example.com';
    const result = validateEmail(email);
    expect(result.isValid).toBe(true);
  });
  
  test('should accept email with dots', () => {
    const email = 'first.last@example.com';
    const result = validateEmail(email);
    expect(result.isValid).toBe(true);
  });
  
  test('should reject invalid email formats', () => {
    const invalidEmails = [
      'notanemail',
      '@example.com',
      'user@',
      'user @example.com'
    ];
    
    invalidEmails.forEach(email => {
      const result = validateEmail(email);
      expect(result.isValid).toBe(false);
    });
  });
});
```

**Run test (should fail):**
```bash
npm test -- email.test.js
# Expected: FAIL - 1 test failed
```

---

## 5. Implement Fix

### Apply Solution
```bash
# Implement fix with backend expert
/backend "Fix email validation to accept plus sign"
```

**Fix Implementation:**
```javascript
// Updated regex to include plus sign
const emailRegex = /^[a-zA-Z0-9._+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

export function validateEmail(email) {
  if (!email || typeof email !== 'string') {
    return {
      isValid: false,
      error: 'Email is required'
    };
  }
  
  const trimmedEmail = email.trim().toLowerCase();
  
  if (!emailRegex.test(trimmedEmail)) {
    return {
      isValid: false,
      error: 'Invalid email format'
    };
  }
  
  return {
    isValid: true,
    email: trimmedEmail
  };
}
```

**Verify test passes:**
```bash
npm test -- email.test.js
# Expected: PASS - All tests passed
```

---

## 6. Comprehensive Testing

### Run Full Test Suite
```bash
# Run all related tests
/test-suite integration --pattern "email|validation|registration"
```

**Testing Checklist:**
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Regression tests pass (ensure no new bugs)
- [ ] Edge cases covered
- [ ] Manual testing in UI
- [ ] Cross-browser testing (if frontend)
- [ ] Performance impact assessed

**Extended Test Scenarios:**
```javascript
describe('Registration with Fixed Email Validation', () => {
  test('successful registration with plus sign email', async () => {
    const response = await api.post('/auth/register', {
      email: 'user+test@example.com',
      password: 'ValidPass123!'
    });
    
    expect(response.status).toBe(201);
    expect(response.data.user.email).toBe('user+test@example.com');
  });
  
  test('handles edge cases', async () => {
    const edgeCases = [
      'user+tag+multiple@example.com',
      'user.name+tag@example.co.uk',
      'user_name+123@subdomain.example.com'
    ];
    
    for (const email of edgeCases) {
      const response = await api.post('/auth/register', {
        email,
        password: 'ValidPass123!'
      });
      expect(response.status).toBe(201);
    }
  });
});
```

---

## 7. Code Review

### Review Changes
```bash
# Focused code review
/code-review --focus security,edge-cases
```

**Review Checklist:**
- [ ] Fix addresses root cause
- [ ] No unintended side effects
- [ ] Error handling appropriate
- [ ] Performance not degraded
- [ ] Security implications considered
- [ ] Code follows style guidelines
- [ ] Tests are comprehensive
- [ ] Documentation updated

---

## 8. Security Validation

### Security Check
```bash
# Security audit on changes
/security-audit "email validation fix"
```

**Security Considerations:**
- Does fix introduce new vulnerabilities?
- Can malicious input bypass validation?
- Are there injection risks?
- Is input sanitized properly?

---

## 9. Create Pull Request

### PR Creation
```bash
# Generate PR with context
/create-pr "Fix email validation to accept plus sign"
```

**PR Template:**
```markdown
## Bug Fix: Email Validation Plus Sign Support

### Issue
Fixes #1234 - Users cannot register with emails containing plus signs

### Root Cause
Email validation regex was missing `+` character in allowed set

### Solution
- Updated regex pattern to include plus sign
- Added comprehensive test coverage
- Tested edge cases (multiple plus signs, combinations with dots)

### Testing
- ✅ Unit tests pass (5 new tests added)
- ✅ Integration tests pass
- ✅ Manual testing completed
- ✅ Regression tests pass

### Impact
- Low risk change (single line regex update)
- No breaking changes
- Improves user experience for affected users

### Rollout Plan
- Deploy to staging for QA validation
- Monitor error rates
- Deploy to production during low-traffic period
```

---

## 10. Deployment & Monitoring

### Deploy Fix
```bash
# Deploy to staging
/deploy-staging bugfix/email-validation

# After validation, deploy to production
/deploy-production bugfix/email-validation
```

**Deployment Checklist:**
- [ ] Staging deployment successful
- [ ] Smoke tests pass
- [ ] Manual QA completed
- [ ] Metrics look healthy
- [ ] Production deployment successful
- [ ] Error rates decreased
- [ ] User reports confirmed fixed

**Monitoring:**
```bash
# Monitor error rates
/monitor-metrics "email validation errors" --duration "1h"

# Check for new issues
/check-errors "registration" --since "deployment"
```

---

## 11. Post-Fix Verification

### Validation Steps
```bash
# Verify fix in production
/verify-fix "email validation" --environment "production"
```

**Verification Checklist:**
- [ ] Original bug no longer reproducible
- [ ] Error rates decreased
- [ ] User confirmations received
- [ ] No new related issues
- [ ] Metrics show improvement

---

## Quick Reference Commands

```bash
# 1. Analyze & Reproduce
/analyze-bug [bug-id]
/reproduce-bug "description"

# 2. Diagnose
/diagnose "issue description"
/analyze-code "path/to/file"

# 3. Test-Driven Fix
/create-test "test description"
/backend "implement fix"

# 4. Validate
/test-suite integration
/security-audit "changes"
/code-review --focus all

# 5. Deploy
/create-pr "fix description"
/deploy-staging bugfix/branch-name
/deploy-production bugfix/branch-name

# 6. Monitor
/monitor-metrics "metric-name"
/verify-fix "fix description"
```

## Bug Priority Matrix

| Severity | Impact | Response Time | Example |
|----------|--------|---------------|---------|
| Critical | System down | Immediate | Payment system failure |
| High | Major feature broken | < 4 hours | Login not working |
| Medium | Feature impaired | < 2 days | Search returns wrong results |
| Low | Minor issue | < 1 week | Button styling issue |

## Best Practices

✅ **Do:**
- Reproduce before fixing
- Write test first (TDD)
- Identify root cause, not symptoms
- Consider edge cases
- Document the fix
- Monitor after deployment

❌ **Don't:**
- Skip reproduction step
- Apply quick fixes without understanding
- Ignore test failures
- Forget to update documentation
- Deploy without monitoring
- Close bug without verification

## Common Pitfalls

1. **Treating symptoms, not root cause**
   - Symptom: Error message unclear
   - Root cause: Missing input validation

2. **Incomplete testing**
   - Fix works for reported case
   - Fails for edge cases

3. **Introducing new bugs**
   - Fix solves one issue
   - Creates another problem

4. **Poor documentation**
   - Fix deployed but not documented
   - Future maintainers confused