#!/bin/bash

echo "🚀 Running rapid MVP feedback checks..."

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

FEEDBACK_SCORE=0
TOTAL_CHECKS=0

# Create reports directory
mkdir -p .claude/reports

# Check if this is a web project
if [ -f "package.json" ]; then
    echo "📦 Web project detected - running frontend checks..."
    
    # TypeScript/ESLint quick check
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    if command_exists "npx" && npm list typescript --depth=0 >/dev/null 2>&1; then
        echo "🔍 Quick TypeScript check..."
        if npx tsc --noEmit --skipLibCheck >/dev/null 2>&1; then
            echo "✅ TypeScript: No type errors"
            FEEDBACK_SCORE=$((FEEDBACK_SCORE + 1))
        else
            echo "⚠️  TypeScript: Type errors detected - fix for better reliability"
        fi
    fi
    
    # Build check (critical for deployment)
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    if npm run build >/dev/null 2>&1; then
        echo "✅ Build: Successful"
        FEEDBACK_SCORE=$((FEEDBACK_SCORE + 1))
    else
        echo "❌ Build: Failed - must fix before deployment"
    fi
    
    # Bundle size check (important for performance)
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    if [ -d "dist" ] || [ -d "build" ] || [ -d ".next" ]; then
        build_dir=""
        [ -d "dist" ] && build_dir="dist"
        [ -d "build" ] && build_dir="build"  
        [ -d ".next" ] && build_dir=".next"
        
        if [ -n "$build_dir" ]; then
            bundle_size=$(du -sh "$build_dir" | cut -f1)
            echo "📊 Bundle size: $bundle_size"
            
            # Simple heuristic: warn if build is > 10MB
            size_mb=$(du -sm "$build_dir" | cut -f1)
            if [ "$size_mb" -lt 10 ]; then
                echo "✅ Bundle size: Reasonable ($bundle_size)"
                FEEDBACK_SCORE=$((FEEDBACK_SCORE + 1))
            else
                echo "⚠️  Bundle size: Large ($bundle_size) - consider optimization"
            fi
        fi
    fi
    
    # Check for essential MVP files
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    essential_files=("README.md" ".env.example")
    missing_files=()
    
    for file in "${essential_files[@]}"; do
        if [ ! -f "$file" ]; then
            missing_files+=("$file")
        fi
    done
    
    if [ ${#missing_files[@]} -eq 0 ]; then
        echo "✅ Essential files: All present"
        FEEDBACK_SCORE=$((FEEDBACK_SCORE + 1))
    else
        echo "⚠️  Missing essential files: ${missing_files[*]}"
    fi
    
    # Security check for exposed secrets
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    if ! find . -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" | grep -v node_modules | xargs grep -l -E "(api[_-]?key|secret|password|token).*=.*['\"][^'\"]{10,}" >/dev/null 2>&1; then
        echo "✅ Security: No hardcoded secrets detected"
        FEEDBACK_SCORE=$((FEEDBACK_SCORE + 1))
    else
        echo "❌ Security: Potential hardcoded secrets found"
    fi
fi

# Database migration check
if [ -f "supabase/migrations" ] || [ -d "prisma/migrations" ] || [ -d "drizzle" ]; then
    echo "🗄️  Database migrations detected..."
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    
    # Check if migrations are up to date
    if command_exists "supabase"; then
        if supabase status >/dev/null 2>&1; then
            echo "✅ Database: Supabase connection healthy"
            FEEDBACK_SCORE=$((FEEDBACK_SCORE + 1))
        else
            echo "⚠️  Database: Supabase connection issues"
        fi
    elif command_exists "prisma"; then
        if npx prisma generate >/dev/null 2>&1; then
            echo "✅ Database: Prisma schema valid"
            FEEDBACK_SCORE=$((FEEDBACK_SCORE + 1))
        else
            echo "⚠️  Database: Prisma schema issues"
        fi
    else
        echo "✅ Database: Migration files present"
        FEEDBACK_SCORE=$((FEEDBACK_SCORE + 1))
    fi
fi

# API health check (if applicable)
if [ -f "api/health" ] || [ -f "pages/api/health.js" ] || [ -f "app/api/health/route.ts" ]; then
    echo "🏥 Health endpoint detected - good for monitoring"
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    FEEDBACK_SCORE=$((FEEDBACK_SCORE + 1))
fi

# Environment configuration check
TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
if [ -f ".env.example" ] && [ -f ".env" ]; then
    # Check if .env has all variables from .env.example
    missing_vars=$(comm -23 <(grep -E '^[A-Z_]' .env.example | cut -d'=' -f1 | sort) <(grep -E '^[A-Z_]' .env | cut -d'=' -f1 | sort))
    if [ -z "$missing_vars" ]; then
        echo "✅ Environment: All required variables set"
        FEEDBACK_SCORE=$((FEEDBACK_SCORE + 1))
    else
        echo "⚠️  Environment: Missing variables: $missing_vars"
    fi
elif [ -f ".env.example" ]; then
    echo "⚠️  Environment: .env.example exists but .env is missing"
else
    echo "✅ Environment: No environment configuration needed"
    FEEDBACK_SCORE=$((FEEDBACK_SCORE + 1))
fi

# Performance hints
echo "🎯 MVP Performance Hints:"
echo "   • Use Next.js Image component for optimized images"
echo "   • Implement loading states for better UX"
echo "   • Add error boundaries for React components"
echo "   • Consider skeleton screens for perceived performance"

# Generate feedback report
feedback_percentage=$((FEEDBACK_SCORE * 100 / TOTAL_CHECKS))
echo ""
echo "📊 MVP Readiness Score: $FEEDBACK_SCORE/$TOTAL_CHECKS ($feedback_percentage%)"

# Save detailed report
cat > .claude/reports/mvp-feedback.json << EOF
{
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%S.%3NZ")",
  "score": $FEEDBACK_SCORE,
  "total_checks": $TOTAL_CHECKS,
  "percentage": $feedback_percentage,
  "deployment_ready": $([ $feedback_percentage -gt 70 ] && echo "true" || echo "false"),
  "critical_issues": $([ $feedback_percentage -lt 50 ] && echo "true" || echo "false")
}
EOF

# Deployment readiness assessment
if [ $feedback_percentage -gt 80 ]; then
    echo "🎉 MVP looks great! Ready for deployment."
    echo "   Next: Deploy to preview environment"
elif [ $feedback_percentage -gt 60 ]; then
    echo "🔧 MVP is almost ready. Address warnings above."
    echo "   Focus: Fix build/security issues before deployment"
else
    echo "🚧 MVP needs work before deployment."
    echo "   Priority: Fix critical issues (build, security, environment)"
fi

echo "✅ Rapid feedback complete!"
exit 0