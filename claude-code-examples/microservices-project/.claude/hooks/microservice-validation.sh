#!/bin/bash

echo "🔍 Validating microservices architecture..."

# Function to check if command exists  
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

FAILED=0

# Validate Docker and Kubernetes configurations
echo "🐳 Validating container configurations..."

# Check Dockerfiles in each service
for dockerfile in $(find . -name "Dockerfile" -not -path "./node_modules/*" -not -path "./.git/*"); do
    service_dir=$(dirname "$dockerfile")
    service_name=$(basename "$service_dir")
    
    echo "🔍 Validating Dockerfile for $service_name..."
    
    # Basic Dockerfile validation
    if ! grep -q "FROM" "$dockerfile"; then
        echo "❌ $dockerfile missing FROM instruction"
        FAILED=1
    fi
    
    if ! grep -q "EXPOSE\|CMD\|ENTRYPOINT" "$dockerfile"; then
        echo "❌ $dockerfile missing EXPOSE, CMD, or ENTRYPOINT instruction"
        FAILED=1
    fi
    
    # Check for multi-stage builds (recommended)
    if ! grep -q "AS " "$dockerfile"; then
        echo "⚠️  $dockerfile: Consider using multi-stage builds for smaller images"
    fi
    
    # Security checks
    if grep -q "USER root\|^USER 0" "$dockerfile"; then
        echo "⚠️  $dockerfile: Running as root user - consider using non-root user"
    fi
done

# Validate Kubernetes manifests
if [ -d "k8s" ] || [ -d "kubernetes" ] || find . -name "*.yaml" -o -name "*.yml" | grep -E "(deployment|service|ingress)" >/dev/null; then
    echo "☸️  Validating Kubernetes manifests..."
    
    if command_exists "kubectl"; then
        # Find and validate Kubernetes YAML files
        for k8s_file in $(find . -name "*.yaml" -o -name "*.yml" | grep -E "(k8s|kubernetes|deployment|service|ingress)"); do
            echo "🔍 Validating $k8s_file..."
            
            if ! kubectl apply --dry-run=client -f "$k8s_file" >/dev/null 2>&1; then
                echo "❌ Invalid Kubernetes manifest: $k8s_file"
                FAILED=1
            fi
        done
    else
        echo "⚠️  kubectl not found - skipping Kubernetes validation"
    fi
fi

# Validate Docker Compose  
if [ -f "docker-compose.yml" ] || [ -f "docker-compose.yaml" ]; then
    echo "🐙 Validating Docker Compose configuration..."
    
    if command_exists "docker-compose"; then
        if ! docker-compose config >/dev/null 2>&1; then
            echo "❌ Invalid docker-compose configuration"
            FAILED=1
        else
            echo "✅ Docker Compose configuration valid"
        fi
    elif command_exists "docker"; then
        if ! docker compose config >/dev/null 2>&1; then
            echo "❌ Invalid docker compose configuration"
            FAILED=1
        else
            echo "✅ Docker Compose configuration valid"
        fi
    fi
fi

# Validate API schemas (OpenAPI/Swagger)
echo "📋 Validating API schemas..."
for api_file in $(find . -name "openapi.yaml" -o -name "swagger.yaml" -o -name "api.yaml"); do
    echo "🔍 Found API schema: $api_file"
    
    # Basic validation - check for required OpenAPI fields
    if ! grep -q "openapi:\|swagger:" "$api_file"; then
        echo "❌ $api_file missing OpenAPI/Swagger version"
        FAILED=1
    fi
    
    if ! grep -q "info:" "$api_file"; then
        echo "❌ $api_file missing info section"
        FAILED=1
    fi
done

# Check for service discovery configurations
echo "🔍 Checking service discovery configurations..."

# Check for service mesh configurations (Istio, Linkerd)
if find . -name "*.yaml" | xargs grep -l "istio.io\|linkerd.io" >/dev/null 2>&1; then
    echo "🕸️  Service mesh configuration detected"
fi

# Check for API Gateway configurations
if find . -name "*.yaml" -o -name "*.json" | xargs grep -l -E "(gateway|ingress|ambassador|kong|nginx)" >/dev/null 2>&1; then
    echo "🚪 API Gateway configuration detected"
fi

# Validate health check endpoints
echo "🏥 Checking for health check implementations..."
for service_dir in $(find . -maxdepth 2 -type d -name "*service*" -o -name "*api*" | head -10); do
    if [ -d "$service_dir" ]; then
        service_name=$(basename "$service_dir")
        
        # Check for health check files
        if find "$service_dir" -name "*health*" -o -name "*ping*" | grep -v node_modules >/dev/null 2>&1; then
            echo "✅ Health check found for $service_name"
        else
            echo "⚠️  No health check found for $service_name"
        fi
    fi
done

# Check for observability configurations  
echo "📊 Checking observability setup..."

# Check for monitoring configurations
if find . -name "prometheus.yml" -o -name "*monitoring*" | grep -v node_modules >/dev/null 2>&1; then
    echo "📈 Monitoring configuration found"
fi

# Check for logging configurations
if find . -name "*logging*" -o -name "fluent*" -o -name "*logstash*" | grep -v node_modules >/dev/null 2>&1; then
    echo "📝 Logging configuration found"
fi

# Check for tracing configurations
if find . -name "*jaeger*" -o -name "*zipkin*" -o -name "*tracing*" | grep -v node_modules >/dev/null 2>&1; then
    echo "🔍 Distributed tracing configuration found"
fi

# Security validation
echo "🔒 Running security checks..."

# Check for secrets in configuration files
if find . -name "*.yaml" -o -name "*.yml" -o -name "*.json" | xargs grep -i -E "(password|secret|key|token)" | grep -v "secretKeyRef\|secretName" >/dev/null 2>&1; then
    echo "⚠️  Potential hardcoded secrets found - please review"
    FAILED=1
fi

# Check for network policies
if find . -name "*.yaml" | xargs grep -l "NetworkPolicy" >/dev/null 2>&1; then
    echo "🛡️  Network policies found"
else
    echo "⚠️  No network policies found - consider implementing for security"
fi

# Performance and reliability checks
echo "⚡ Checking performance and reliability configurations..."

# Check for resource limits
if find . -name "*.yaml" | xargs grep -l -E "(limits|requests):" >/dev/null 2>&1; then
    echo "📊 Resource limits configured"
else
    echo "⚠️  No resource limits found - consider adding for better resource management"
fi

# Check for horizontal pod autoscaling
if find . -name "*.yaml" | xargs grep -l "HorizontalPodAutoscaler" >/dev/null 2>&1; then
    echo "📈 Auto-scaling configured"
fi

# Final result
if [ $FAILED -eq 0 ]; then
    echo "🎉 Microservices validation completed successfully!"
    exit 0
else
    echo "💥 Microservices validation failed. Please fix the issues above."
    exit 1
fi