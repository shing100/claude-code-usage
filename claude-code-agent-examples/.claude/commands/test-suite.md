# Test Suite Command

Run comprehensive test suite with coverage analysis and quality reporting.

## Usage
```
/test-suite [test-type] [--coverage] [--parallel]
```

## Parameters
- `test-type`: Type of tests to run (unit, integration, e2e, all)
- `--coverage`: Generate coverage reports
- `--parallel`: Run tests in parallel for faster execution

## What this does

1. **Test Execution**
   - Unit tests with mocking and isolation
   - Integration tests for component interaction
   - End-to-end tests for user workflows
   - Performance tests for critical paths

2. **Coverage Analysis**
   - Line coverage measurement
   - Branch coverage analysis
   - Function coverage tracking
   - Uncovered code identification

3. **Quality Metrics**
   - Test execution time analysis
   - Flaky test detection
   - Test reliability scoring
   - Performance regression detection

4. **Reporting**
   - Detailed test results
   - Coverage reports with visual indicators
   - Performance benchmarks
   - Quality trend analysis

## Example Usage

```bash
# Run all tests with coverage
/test-suite all --coverage

# Run only unit tests in parallel
/test-suite unit --parallel

# Run integration tests
/test-suite integration
```

## Test Configuration

```yaml
# .testconfig.yml
test_suite:
  unit:
    framework: pytest
    pattern: "tests/unit/**/*_test.py"
    coverage_threshold: 90
  
  integration:
    framework: pytest
    pattern: "tests/integration/**/*_test.py"
    database: test_db
    
  e2e:
    framework: playwright
    pattern: "tests/e2e/**/*.spec.js"
    browsers: [chromium, firefox, webkit]
```

## Quality Gates

- [ ] All tests pass
- [ ] Coverage ≥ 80% (unit), ≥ 70% (integration)
- [ ] No flaky tests detected
- [ ] Performance within acceptable thresholds
- [ ] Security tests pass
- [ ] Accessibility tests pass (for UI components)