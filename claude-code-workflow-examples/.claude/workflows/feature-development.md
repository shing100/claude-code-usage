# Feature Development Workflow

A comprehensive workflow for developing new features from specification to deployment.

## Workflow Stages

### 1. Planning & Specification
**Goal**: Create clear requirements and technical specifications

```bash
# Generate feature specification
/plan-feature [feature-name]

# Example
/plan-feature "user authentication with OAuth"
```

**What happens:**
- Analyze feature requirements
- Define acceptance criteria
- Identify technical dependencies
- Create architecture overview
- Estimate complexity and timeline

**Output:**
```markdown
# Feature Specification: User Authentication with OAuth

## Requirements
- OAuth 2.0 integration with Google, GitHub
- Secure token storage and refresh
- User profile management
- Session management

## Technical Design
- Backend: JWT token generation, OAuth provider integration
- Frontend: Login buttons, redirect handling, profile display
- Database: User table, OAuth token table

## Acceptance Criteria
- [ ] Users can login with Google
- [ ] Users can login with GitHub
- [ ] Tokens refresh automatically
- [ ] Sessions persist across browser restarts

## Timeline: 3-5 days
```

---

### 2. Backend Implementation
**Goal**: Implement server-side logic and APIs

```bash
# Use backend developer agent
/backend "Implement OAuth authentication endpoints"
```

**Implementation Steps:**
1. **Setup OAuth Configuration**
   - Configure OAuth providers (Google, GitHub)
   - Set environment variables for client IDs and secrets
   - Create OAuth callback routes

2. **Create API Endpoints**
   ```
   POST /auth/oauth/google/login
   POST /auth/oauth/github/login
   GET  /auth/oauth/callback
   POST /auth/refresh-token
   GET  /auth/profile
   POST /auth/logout
   ```

3. **Implement Authentication Logic**
   - OAuth token exchange
   - JWT token generation
   - Refresh token rotation
   - Session management

4. **Add Security Measures**
   - CSRF protection
   - Rate limiting
   - Secure cookie settings
   - Token encryption

**Code Structure:**
```
backend/
├── routes/
│   └── auth.py
├── services/
│   ├── oauth_service.py
│   └── token_service.py
├── models/
│   ├── user.py
│   └── oauth_token.py
└── middleware/
    └── auth_middleware.py
```

---

### 3. Frontend Implementation
**Goal**: Create user interface components

```bash
# Use frontend developer agent
/frontend "Create OAuth login UI components"
```

**Implementation Steps:**
1. **Create Login Components**
   - Login button components
   - OAuth provider selection
   - Loading states
   - Error handling

2. **Implement Authentication Flow**
   - OAuth redirect handling
   - Token storage (secure, httpOnly cookies)
   - Automatic token refresh
   - Protected route wrapper

3. **User Profile Management**
   - Profile display component
   - Logout functionality
   - Session indicator

**Component Structure:**
```
frontend/
├── components/
│   ├── auth/
│   │   ├── LoginButton.tsx
│   │   ├── OAuthCallback.tsx
│   │   ├── ProfileMenu.tsx
│   │   └── ProtectedRoute.tsx
│   └── common/
│       └── LoadingSpinner.tsx
└── hooks/
    ├── useAuth.ts
    └── useOAuthRedirect.ts
```

---

### 4. Testing
**Goal**: Ensure feature works correctly across scenarios

```bash
# Run comprehensive test suite
/test-feature "OAuth authentication"
```

**Testing Strategy:**

**Backend Tests:**
- Unit tests for OAuth service
- Integration tests for auth endpoints
- Security tests for token handling
- Load tests for concurrent users

**Frontend Tests:**
- Component unit tests
- Integration tests for auth flow
- E2E tests with Playwright
- Cross-browser compatibility

**Test Scenarios:**
```javascript
describe('OAuth Authentication', () => {
  test('User can login with Google', async () => {
    // Test implementation
  });
  
  test('User can login with GitHub', async () => {
    // Test implementation
  });
  
  test('Token refreshes automatically', async () => {
    // Test implementation
  });
  
  test('Logout clears all session data', async () => {
    // Test implementation
  });
  
  test('Handles OAuth errors gracefully', async () => {
    // Test implementation
  });
});
```

---

### 5. Security Review
**Goal**: Validate security implementation

```bash
# Run security audit
/security-audit "OAuth authentication feature"
```

**Security Checklist:**
- [ ] OAuth implementation follows best practices
- [ ] Tokens stored securely (httpOnly, secure, sameSite)
- [ ] CSRF protection implemented
- [ ] Rate limiting on auth endpoints
- [ ] SQL injection prevention
- [ ] XSS protection
- [ ] Secure redirect validation
- [ ] Token expiration and refresh logic
- [ ] Audit logging for auth events

---

### 6. Code Review
**Goal**: Ensure code quality and maintainability

```bash
# Comprehensive code review
/code-review --focus all
```

**Review Areas:**
- Code structure and organization
- Error handling and edge cases
- Performance optimization opportunities
- Documentation completeness
- Test coverage adequacy
- Security implementation
- Accessibility compliance

---

### 7. Documentation
**Goal**: Create comprehensive documentation

```bash
# Generate documentation
/document "OAuth authentication feature"
```

**Documentation Deliverables:**

**API Documentation:**
```markdown
## OAuth Authentication API

### Login with Google
`POST /auth/oauth/google/login`

Initiates OAuth login flow with Google.

**Response:**
```json
{
  "redirect_url": "https://accounts.google.com/o/oauth2/v2/auth?..."
}
```

### OAuth Callback
`GET /auth/oauth/callback`

Handles OAuth provider callback and issues JWT tokens.
```

**User Guide:**
- How to login
- Supported providers
- Troubleshooting common issues

**Developer Guide:**
- Architecture overview
- Setup instructions
- Configuration options
- Testing procedures

---

### 8. Deployment
**Goal**: Deploy feature to production

```bash
# Deploy to staging first
/deploy-staging feature/oauth-auth

# After validation, deploy to production
/deploy-production feature/oauth-auth
```

**Deployment Steps:**
1. Deploy to staging environment
2. Run smoke tests
3. Perform manual QA
4. Monitor metrics and logs
5. Deploy to production with canary release
6. Monitor production metrics
7. Gradually increase traffic
8. Full rollout

**Monitoring:**
- Success/failure rates
- Response times
- Error logs
- User adoption metrics

---

## Complete Workflow Commands

```bash
# 1. Plan
/plan-feature "OAuth authentication"

# 2. Backend
/backend "Implement OAuth authentication endpoints"

# 3. Frontend  
/frontend "Create OAuth login UI components"

# 4. Test
/test-feature "OAuth authentication"

# 5. Security
/security-audit "OAuth authentication feature"

# 6. Review
/code-review --focus all

# 7. Document
/document "OAuth authentication feature"

# 8. Deploy
/deploy-staging feature/oauth-auth
/deploy-production feature/oauth-auth
```

## Best Practices

✅ **Do:**
- Start with clear specifications
- Implement incrementally
- Test at each stage
- Review security thoroughly
- Document comprehensively
- Deploy gradually

❌ **Don't:**
- Skip planning phase
- Ignore security concerns
- Skip testing
- Deploy without monitoring
- Forget documentation
- Rush deployment

## Success Criteria

- [ ] All acceptance criteria met
- [ ] Tests passing (>90% coverage)
- [ ] Security audit passed
- [ ] Code review approved
- [ ] Documentation complete
- [ ] Successfully deployed to production
- [ ] Monitoring shows healthy metrics