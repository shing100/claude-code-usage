# Code Refactoring Workflow

A systematic approach to improving code quality without changing functionality.

## Refactoring Philosophy

> "Make it work, make it right, make it fast" - Kent Beck

## Workflow Overview

```
Assess → Plan → Test → Refactor → Validate → Document
```

---

## 1. Assessment & Analysis

### Identify Refactoring Needs
```bash
# Analyze code quality
/analyze-code-quality --scope project
```

**Common Refactoring Triggers:**
- Code smells detected
- Low test coverage
- High complexity metrics
- Duplicated code
- Performance issues
- Outdated patterns
- Technical debt accumulation

**Assessment Metrics:**
```javascript
{
  "complexity": {
    "cyclomatic": 45,        // Target: < 10 per function
    "cognitive": 32          // Target: < 15 per function
  },
  "duplication": {
    "percentage": 15.2,      // Target: < 3%
    "blocks": 8
  },
  "test_coverage": {
    "lines": 62,             // Target: > 80%
    "branches": 54           // Target: > 70%
  },
  "maintainability_index": 58  // Target: > 85
}
```

### Code Smell Detection
```bash
# Identify code smells
/detect-code-smells "src/services/user-service.js"
```

**Common Code Smells:**

**1. Long Method**
```javascript
// Before: 200+ lines
function processUserRegistration(userData) {
  // Validation (30 lines)
  // Data transformation (40 lines)
  // Database operations (50 lines)
  // Email sending (30 lines)
  // Audit logging (20 lines)
  // Response formatting (30 lines)
}
```

**2. Large Class**
```javascript
// UserService with 50+ methods
class UserService {
  createUser() {}
  updateUser() {}
  deleteUser() {}
  // ... 47 more methods
}
```

**3. Duplicate Code**
```javascript
// Pattern repeated in 5 different files
function validateEmail(email) {
  const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return regex.test(email);
}
```

**4. Long Parameter List**
```javascript
// Before: Too many parameters
function createOrder(userId, productId, quantity, price, 
                    discount, shippingAddress, billingAddress,
                    paymentMethod, notes, giftWrap) {
  // ...
}
```

**5. Feature Envy**
```javascript
// Method uses more data from another class
class Order {
  calculateShipping() {
    const weight = this.product.getWeight();
    const dimensions = this.product.getDimensions();
    const category = this.product.getCategory();
    // Uses product data extensively
  }
}
```

---

## 2. Planning Refactoring Strategy

### Create Refactoring Plan
```bash
# Generate refactoring strategy
/plan-refactoring "user-service.js"
```

**Refactoring Plan Template:**
```markdown
## Refactoring Plan: UserService

### Current Issues
1. Long method: processUserRegistration (240 lines)
2. God class: UserService (52 methods)
3. Code duplication: email validation (5 occurrences)
4. High complexity: cyclomatic = 45

### Proposed Changes
1. **Extract Methods** (Priority: High)
   - Break down processUserRegistration into smaller functions
   - Target: < 20 lines per function

2. **Split Class** (Priority: High)
   - Extract UserValidationService
   - Extract UserNotificationService
   - Extract UserAuditService

3. **Extract Common Utilities** (Priority: Medium)
   - Create shared email validator
   - Create shared data transformers

4. **Reduce Complexity** (Priority: High)
   - Simplify conditional logic
   - Extract guard clauses
   - Use early returns

### Timeline
- Phase 1 (1-2 days): Extract methods, improve testability
- Phase 2 (2-3 days): Split classes, reorganize structure
- Phase 3 (1 day): Extract utilities, reduce duplication

### Risk Assessment
- Low risk: Well-tested code with high coverage
- Mitigation: Refactor in small steps with continuous testing
```

---

## 3. Establish Safety Net (Tests First)

### Ensure Test Coverage
```bash
# Check current test coverage
/test-coverage "src/services/user-service.js"

# Add missing tests if coverage low
/create-tests "user-service" --coverage-target 90
```

**Test Coverage Strategy:**
```javascript
describe('UserService - Before Refactoring', () => {
  // Characterization tests - document current behavior
  test('processUserRegistration: successful registration', async () => {
    const result = await userService.processUserRegistration(validUserData);
    expect(result).toMatchSnapshot();
  });
  
  test('processUserRegistration: handles validation errors', async () => {
    const result = await userService.processUserRegistration(invalidUserData);
    expect(result.errors).toBeDefined();
  });
  
  // Test all edge cases
  test('processUserRegistration: handles duplicate email', async () => {
    // ...
  });
  
  test('processUserRegistration: handles database errors', async () => {
    // ...
  });
});
```

**Coverage Goals:**
- Line coverage: ≥ 90%
- Branch coverage: ≥ 85%
- All edge cases covered
- All error paths tested

---

## 4. Refactoring Techniques

### Technique 1: Extract Method
```bash
# Apply extract method refactoring
/refactor extract-method "validateUserInput" --from "processUserRegistration"
```

**Before:**
```javascript
async function processUserRegistration(userData) {
  // Validation logic (30 lines)
  if (!userData.email) {
    throw new Error('Email required');
  }
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailRegex.test(userData.email)) {
    throw new Error('Invalid email');
  }
  if (!userData.password || userData.password.length < 8) {
    throw new Error('Password must be at least 8 characters');
  }
  // ... more validation
  
  // Rest of registration logic (210 lines)
}
```

**After:**
```javascript
async function processUserRegistration(userData) {
  validateUserInput(userData);
  const transformedData = transformUserData(userData);
  const user = await saveUser(transformedData);
  await sendWelcomeEmail(user);
  await logAuditEvent('user_registered', user.id);
  return formatUserResponse(user);
}

function validateUserInput(userData) {
  validateRequiredFields(userData);
  validateEmail(userData.email);
  validatePassword(userData.password);
  validateAge(userData.age);
}

function validateEmail(email) {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailRegex.test(email)) {
    throw new ValidationError('Invalid email format');
  }
}

function validatePassword(password) {
  if (!password || password.length < 8) {
    throw new ValidationError('Password must be at least 8 characters');
  }
  if (!/[A-Z]/.test(password) || !/[0-9]/.test(password)) {
    throw new ValidationError('Password must contain uppercase and number');
  }
}
```

### Technique 2: Extract Class
```bash
# Split large class
/refactor extract-class "UserValidationService" --from "UserService"
```

**Before:**
```javascript
class UserService {
  async createUser(userData) { }
  async updateUser(userId, data) { }
  async deleteUser(userId) { }
  
  // Validation methods
  validateEmail(email) { }
  validatePassword(password) { }
  validateAge(age) { }
  
  // Notification methods
  sendWelcomeEmail(user) { }
  sendPasswordResetEmail(user) { }
  
  // Audit methods
  logUserCreated(userId) { }
  logUserUpdated(userId) { }
  
  // ... 40 more methods
}
```

**After:**
```javascript
// user-service.js
class UserService {
  constructor() {
    this.validator = new UserValidationService();
    this.notifier = new UserNotificationService();
    this.auditor = new UserAuditService();
  }
  
  async createUser(userData) {
    this.validator.validateUserData(userData);
    const user = await this.repository.save(userData);
    await this.notifier.sendWelcomeEmail(user);
    await this.auditor.logUserCreated(user.id);
    return user;
  }
  
  async updateUser(userId, data) {
    this.validator.validateUpdateData(data);
    const user = await this.repository.update(userId, data);
    await this.auditor.logUserUpdated(userId);
    return user;
  }
}

// user-validation-service.js
class UserValidationService {
  validateUserData(userData) {
    this.validateEmail(userData.email);
    this.validatePassword(userData.password);
    this.validateAge(userData.age);
  }
  
  validateEmail(email) { }
  validatePassword(password) { }
  validateAge(age) { }
}

// user-notification-service.js
class UserNotificationService {
  async sendWelcomeEmail(user) { }
  async sendPasswordResetEmail(user) { }
}

// user-audit-service.js
class UserAuditService {
  async logUserCreated(userId) { }
  async logUserUpdated(userId) { }
}
```

### Technique 3: Replace Conditional with Polymorphism
```bash
/refactor replace-conditional-with-polymorphism "calculateShipping"
```

**Before:**
```javascript
function calculateShipping(order) {
  if (order.shippingType === 'standard') {
    return order.weight * 0.5 + 5.0;
  } else if (order.shippingType === 'express') {
    return order.weight * 1.0 + 10.0;
  } else if (order.shippingType === 'overnight') {
    return order.weight * 2.0 + 20.0;
  } else if (order.shippingType === 'international') {
    return order.weight * 3.0 + 50.0;
  }
  return 0;
}
```

**After:**
```javascript
// Strategy pattern
class ShippingStrategy {
  calculate(order) {
    throw new Error('Must implement calculate method');
  }
}

class StandardShipping extends ShippingStrategy {
  calculate(order) {
    return order.weight * 0.5 + 5.0;
  }
}

class ExpressShipping extends ShippingStrategy {
  calculate(order) {
    return order.weight * 1.0 + 10.0;
  }
}

class OvernightShipping extends ShippingStrategy {
  calculate(order) {
    return order.weight * 2.0 + 20.0;
  }
}

class InternationalShipping extends ShippingStrategy {
  calculate(order) {
    return order.weight * 3.0 + 50.0;
  }
}

// Factory
const shippingStrategies = {
  standard: new StandardShipping(),
  express: new ExpressShipping(),
  overnight: new OvernightShipping(),
  international: new InternationalShipping()
};

function calculateShipping(order) {
  const strategy = shippingStrategies[order.shippingType];
  if (!strategy) {
    throw new Error(`Unknown shipping type: ${order.shippingType}`);
  }
  return strategy.calculate(order);
}
```

### Technique 4: Introduce Parameter Object
```bash
/refactor introduce-parameter-object "OrderParams" --function "createOrder"
```

**Before:**
```javascript
function createOrder(userId, productId, quantity, price, 
                    discount, shippingAddress, billingAddress,
                    paymentMethod, notes, giftWrap) {
  // Implementation
}

// Usage
createOrder(
  123,
  456,
  2,
  29.99,
  0.1,
  '123 Main St',
  '123 Main St',
  'credit_card',
  'Please deliver after 5pm',
  true
);
```

**After:**
```javascript
class OrderParams {
  constructor({
    userId,
    productId,
    quantity,
    price,
    discount = 0,
    shippingAddress,
    billingAddress,
    paymentMethod,
    notes = '',
    giftWrap = false
  }) {
    this.userId = userId;
    this.productId = productId;
    this.quantity = quantity;
    this.price = price;
    this.discount = discount;
    this.shippingAddress = shippingAddress;
    this.billingAddress = billingAddress;
    this.paymentMethod = paymentMethod;
    this.notes = notes;
    this.giftWrap = giftWrap;
  }
}

function createOrder(params) {
  // Implementation uses params.userId, params.productId, etc.
}

// Usage
createOrder(new OrderParams({
  userId: 123,
  productId: 456,
  quantity: 2,
  price: 29.99,
  discount: 0.1,
  shippingAddress: '123 Main St',
  billingAddress: '123 Main St',
  paymentMethod: 'credit_card',
  notes: 'Please deliver after 5pm',
  giftWrap: true
}));
```

---

## 5. Continuous Testing During Refactoring

### Test After Each Change
```bash
# Run tests after each refactoring step
/test-suite unit --watch

# Or run specific test file
npm test -- user-service.test.js --watch
```

**Testing Workflow:**
1. Run all tests before starting
2. Make small refactoring change
3. Run tests immediately
4. If tests fail, revert and reconsider
5. If tests pass, commit change
6. Repeat

**Commit Strategy:**
```bash
# Commit after each successful refactoring step
git add src/services/user-service.js
git commit -m "refactor: extract validateUserInput method"

git add src/services/user-validation-service.js
git commit -m "refactor: extract UserValidationService class"
```

---

## 6. Performance Validation

### Benchmark Before and After
```bash
# Run performance benchmarks
/benchmark "user-service" --compare baseline
```

**Performance Metrics:**
```javascript
{
  "before_refactoring": {
    "processUserRegistration": {
      "avg_time_ms": 245,
      "p95_time_ms": 380,
      "memory_mb": 45
    }
  },
  "after_refactoring": {
    "processUserRegistration": {
      "avg_time_ms": 198,     // 19% improvement
      "p95_time_ms": 285,     // 25% improvement
      "memory_mb": 38         // 16% improvement
    }
  }
}
```

---

## 7. Code Review

### Review Refactoring Changes
```bash
/code-review --focus maintainability,readability
```

**Review Checklist:**
- [ ] Code is more readable
- [ ] Complexity reduced
- [ ] Duplication eliminated
- [ ] Tests still pass
- [ ] Performance not degraded
- [ ] No functionality changed
- [ ] Documentation updated

---

## 8. Documentation Updates

### Update Documentation
```bash
/update-docs "user-service refactoring"
```

**Documentation Updates:**
```markdown
## UserService Architecture (Updated)

### Class Structure
- `UserService` - Main orchestration
- `UserValidationService` - Input validation
- `UserNotificationService` - Email notifications
- `UserAuditService` - Audit logging

### Method Breakdown
Previously one 240-line method has been refactored into:
- `processUserRegistration()` - 15 lines (orchestration)
- `validateUserInput()` - 8 lines
- `transformUserData()` - 12 lines
- `saveUser()` - 10 lines
- `sendWelcomeEmail()` - 8 lines
- `logAuditEvent()` - 6 lines

### Benefits
- 60% reduction in cyclomatic complexity
- 40% improvement in test coverage
- 25% performance improvement
- Improved maintainability and readability
```

---

## Quick Command Reference

```bash
# Assessment
/analyze-code-quality --scope project
/detect-code-smells "file-path"
/test-coverage "file-path"

# Planning
/plan-refactoring "file-path"

# Refactoring
/refactor extract-method "new-method-name"
/refactor extract-class "NewClassName"
/refactor rename "oldName" "newName"

# Validation
/test-suite unit --watch
/benchmark "component-name"
/code-review --focus maintainability

# Documentation
/update-docs "refactoring description"
```

## Refactoring Catalog

### Code-Level Refactorings
- Extract Method
- Extract Class
- Inline Method
- Move Method
- Rename Variable/Method/Class
- Replace Magic Number with Named Constant
- Introduce Parameter Object
- Remove Dead Code

### Class-Level Refactorings
- Extract Superclass
- Extract Interface
- Pull Up Method
- Push Down Method
- Replace Inheritance with Delegation

### Conditional Refactorings
- Decompose Conditional
- Consolidate Conditional Expression
- Replace Conditional with Polymorphism
- Replace Nested Conditional with Guard Clauses

## Best Practices

✅ **Do:**
- Test before refactoring
- Make small, incremental changes
- Test after each change
- Commit frequently
- Keep functionality unchanged
- Improve one aspect at a time

❌ **Don't:**
- Refactor without tests
- Mix refactoring with new features
- Make large sweeping changes
- Ignore performance impact
- Skip code review
- Forget to update documentation

## Success Metrics

### Code Quality Improvements
- Cyclomatic complexity: < 10 per function
- Cognitive complexity: < 15 per function
- Code duplication: < 3%
- Test coverage: > 85%
- Maintainability index: > 85

### Development Impact
- Reduced bug rate
- Faster feature development
- Improved team velocity
- Better code comprehension
- Easier onboarding