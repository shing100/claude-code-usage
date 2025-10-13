# Code Review Command

Perform comprehensive code review with security, performance, and maintainability analysis.

## Usage
```
/code-review [file-pattern] [--focus area]
```

## Parameters
- `file-pattern`: Glob pattern for files to review (default: current changes)
- `--focus`: Specific area to focus on (security, performance, maintainability, style)

## What this does

1. **Code Quality Analysis**
   - Style guide compliance
   - Code complexity assessment
   - Naming convention review
   - Documentation coverage

2. **Security Review**
   - Vulnerability pattern detection
   - Input validation analysis
   - Authentication/authorization checks
   - Secrets and sensitive data exposure

3. **Performance Analysis**
   - Algorithm complexity review
   - Database query optimization
   - Memory usage patterns
   - Caching opportunities

4. **Maintainability Assessment**
   - Code duplication detection
   - Dependency analysis
   - Test coverage evaluation
   - Refactoring opportunities

## Example Output

```
## Code Review Summary

### Overall Assessment: B+ (Good with room for improvement)

### Security Issues (2 found)
🚨 HIGH: Potential SQL injection in user_service.py:45
⚠️ MEDIUM: Hardcoded API key in config.py:12

### Performance Concerns (1 found)
🐌 N+1 query pattern in get_user_posts() function

### Maintainability Suggestions (3 found)
🔧 Extract common validation logic into utility functions
🔧 Add type hints to improve code clarity
🔧 Increase test coverage for edge cases

### Positive Observations
✅ Good error handling patterns
✅ Clear function naming
✅ Consistent code formatting
```

## Review Checklist

- [ ] Security vulnerabilities addressed
- [ ] Performance bottlenecks identified
- [ ] Code follows style guidelines
- [ ] Tests cover new functionality
- [ ] Documentation is up to date
- [ ] Error handling is appropriate
- [ ] Dependencies are necessary and secure