# API Documentation Generator

Generate comprehensive API documentation with examples and interactive testing capabilities.

## Usage
```
/api-docs [format] [--output path] [--include-examples]
```

## Parameters
- `format`: Output format (openapi, markdown, html, postman)
- `--output`: Output directory or file path
- `--include-examples`: Include request/response examples

## What this does

1. **API Discovery**
   - Scan codebase for API endpoints
   - Extract route definitions and handlers
   - Identify request/response schemas
   - Detect authentication requirements

2. **Schema Generation**
   - OpenAPI 3.0 specification creation
   - Request/response model definitions
   - Parameter validation rules
   - Error response documentation

3. **Documentation Creation**
   - Interactive API explorer
   - Code examples in multiple languages
   - Authentication flow documentation
   - Rate limiting and usage guidelines

4. **Quality Validation**
   - Schema validation and consistency checks
   - Example request/response validation
   - Documentation completeness analysis
   - Accessibility compliance for docs

## Supported Frameworks

### Python
- **FastAPI**: Automatic OpenAPI generation
- **Django REST Framework**: Serializer introspection
- **Flask**: Route and decorator analysis
- **Starlette**: ASGI endpoint discovery

### JavaScript/TypeScript
- **Express.js**: Route handler analysis
- **NestJS**: Decorator-based documentation
- **Koa**: Middleware and route scanning
- **Next.js**: API route discovery

### Other Languages
- **Go**: Gin, Echo framework support
- **Java**: Spring Boot annotation scanning
- **C#**: ASP.NET Core controller analysis
- **Ruby**: Rails controller documentation

## Output Formats

### OpenAPI Specification
```yaml
openapi: 3.0.0
info:
  title: Example API
  version: 1.0.0
paths:
  /users:
    get:
      summary: List users
      parameters:
        - name: limit
          in: query
          schema:
            type: integer
            default: 10
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/User'
```

### Markdown Documentation
```markdown
# API Reference

## Authentication
All API requests require authentication using Bearer tokens.

## Endpoints

### GET /users
List all users with optional pagination.

**Parameters:**
- `limit` (query, optional): Number of users to return (default: 10)
- `offset` (query, optional): Number of users to skip (default: 0)

**Example Request:**
```bash
curl -H "Authorization: Bearer token" \
     "https://api.example.com/users?limit=5"
```

**Example Response:**
```json
{
  "users": [...],
  "total": 100,
  "page": 1
}
```
```

### Interactive HTML
- **Swagger UI**: Interactive API testing interface
- **Redoc**: Clean, responsive documentation
- **Custom**: Branded documentation with company styling
- **Postman Collection**: Importable collection for testing

## Configuration

```yaml
# api-docs.yml
documentation:
  title: "Example API"
  version: "1.0.0"
  description: "Comprehensive API for example application"
  
  contact:
    name: "API Support"
    email: "api-support@example.com"
    
  servers:
    - url: "https://api.example.com"
      description: "Production server"
    - url: "https://staging-api.example.com"
      description: "Staging server"
      
  security:
    - bearerAuth: []
    
  examples:
    include_all: true
    languages: [curl, python, javascript, go]
    
  output:
    openapi: "./docs/openapi.yml"
    html: "./docs/api.html"
    markdown: "./docs/API.md"
```

## Advanced Features

### Code Examples
```python
# Python example
import requests

response = requests.get(
    "https://api.example.com/users",
    headers={"Authorization": "Bearer your-token"},
    params={"limit": 10}
)
users = response.json()
```

```javascript
// JavaScript example
const response = await fetch('https://api.example.com/users?limit=10', {
  headers: {
    'Authorization': 'Bearer your-token'
  }
});
const users = await response.json();
```

### Authentication Documentation
- OAuth 2.0 flow documentation
- API key usage examples
- JWT token handling
- Rate limiting guidelines
- Error handling patterns

### Testing Integration
- **Postman Collections**: Auto-generated collections
- **Insomnia Workspace**: Importable workspace files
- **curl Commands**: Copy-paste ready commands
- **SDK Examples**: Language-specific SDK usage

## Quality Checks

- [ ] All endpoints documented
- [ ] Request/response schemas defined
- [ ] Authentication methods explained
- [ ] Error responses documented
- [ ] Rate limiting information included
- [ ] Examples tested and validated
- [ ] Documentation is accessible and readable

## Example Output

```
📚 Generating API documentation...

✅ Discovered 25 endpoints
✅ Generated OpenAPI specification
✅ Created interactive HTML documentation
✅ Generated Postman collection
✅ Validated all examples

📖 Documentation generated successfully:
   - OpenAPI: ./docs/openapi.yml
   - HTML: ./docs/api.html
   - Markdown: ./docs/API.md
   - Postman: ./docs/api.postman_collection.json

🌐 Preview: http://localhost:8080/docs
```