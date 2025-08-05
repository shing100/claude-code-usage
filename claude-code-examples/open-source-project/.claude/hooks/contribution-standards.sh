#!/bin/bash

echo "🌟 Validating open source contribution standards..."

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

STANDARDS_SCORE=0
TOTAL_STANDARDS=0

# Create reports directory
mkdir -p .claude/reports

# Check for essential open source files
echo "📄 Checking essential OSS files..."
essential_files=(
    "README.md"
    "LICENSE"
    "CONTRIBUTING.md"
    "CODE_OF_CONDUCT.md"
    "CHANGELOG.md"
)

missing_files=()
for file in "${essential_files[@]}"; do
    TOTAL_STANDARDS=$((TOTAL_STANDARDS + 1))
    if [ -f "$file" ]; then
        echo "✅ $file: Present"
        STANDARDS_SCORE=$((STANDARDS_SCORE + 1))
    else
        echo "❌ $file: Missing"
        missing_files+=("$file")
    fi
done

# Check README quality
if [ -f "README.md" ]; then
    echo "📖 Analyzing README.md quality..."
    
    readme_sections=(
        "## Installation"
        "## Usage"
        "## Contributing"
        "## License"
    )
    
    readme_quality=0
    for section in "${readme_sections[@]}"; do
        if grep -q "$section" README.md; then
            readme_quality=$((readme_quality + 1))
        fi
    done
    
    TOTAL_STANDARDS=$((TOTAL_STANDARDS + 1))
    if [ $readme_quality -ge 3 ]; then
        echo "✅ README.md: Well-structured ($readme_quality/4 sections)"
        STANDARDS_SCORE=$((STANDARDS_SCORE + 1))
    else
        echo "⚠️  README.md: Missing key sections ($readme_quality/4 sections)"
    fi
fi

# Check package.json for Node.js projects
if [ -f "package.json" ]; then
    echo "📦 Analyzing package.json for OSS standards..."
    
    # Check for required fields
    required_fields=("name" "version" "description" "repository" "author" "license")
    missing_fields=()
    
    for field in "${required_fields[@]}"; do
        TOTAL_STANDARDS=$((TOTAL_STANDARDS + 1))
        if jq -e ".$field" package.json >/dev/null 2>&1; then
            echo "✅ package.json.$field: Present"
            STANDARDS_SCORE=$((STANDARDS_SCORE + 1))
        else
            echo "❌ package.json.$field: Missing"
            missing_fields+=("$field")
        fi
    done
    
    # Check for helpful scripts
    TOTAL_STANDARDS=$((TOTAL_STANDARDS + 1))
    helpful_scripts=("test" "lint" "format" "docs")
    script_count=0
    
    for script in "${helpful_scripts[@]}"; do
        if jq -e ".scripts.\"$script\"" package.json >/dev/null 2>&1; then
            script_count=$((script_count + 1))
        fi
    done
    
    if [ $script_count -ge 2 ]; then
        echo "✅ package.json scripts: Good coverage ($script_count/4 helpful scripts)"
        STANDARDS_SCORE=$((STANDARDS_SCORE + 1))
    else
        echo "⚠️  package.json scripts: Limited ($script_count/4 helpful scripts)"
    fi
    
    # Check for engines field (helps contributors)
    TOTAL_STANDARDS=$((TOTAL_STANDARDS + 1))
    if jq -e ".engines" package.json >/dev/null 2>&1; then
        echo "✅ package.json.engines: Specified (helps contributors)"
        STANDARDS_SCORE=$((STANDARDS_SCORE + 1))
    else
        echo "⚠️  package.json.engines: Not specified"
    fi
fi

# Check for GitHub workflows
echo "🔄 Checking CI/CD setup..."
TOTAL_STANDARDS=$((TOTAL_STANDARDS + 1))
if [ -d ".github/workflows" ]; then
    workflow_count=$(find .github/workflows -name "*.yml" -o -name "*.yaml" | wc -l)
    if [ $workflow_count -gt 0 ]; then
        echo "✅ GitHub Actions: $workflow_count workflow(s) configured"
        STANDARDS_SCORE=$((STANDARDS_SCORE + 1))
        
        # Check for common workflows
        common_workflows=("test" "ci" "release" "lint")
        for workflow in "${common_workflows[@]}"; do
            if find .github/workflows -name "*$workflow*" | head -1 >/dev/null 2>&1; then
                echo "  ✅ $workflow workflow detected"
            fi
        done
    else
        echo "⚠️  GitHub Actions: Directory exists but no workflows found"
    fi
else
    echo "⚠️  GitHub Actions: No workflows directory found"
fi

# Check for issue and PR templates
echo "📝 Checking community templates..."
template_dirs=(".github/ISSUE_TEMPLATE" ".github/PULL_REQUEST_TEMPLATE")
template_score=0

for dir in "${template_dirs[@]}"; do
    TOTAL_STANDARDS=$((TOTAL_STANDARDS + 1))
    if [ -d "$dir" ] || [ -f "${dir}.md" ]; then
        echo "✅ $(basename $dir): Present"
        STANDARDS_SCORE=$((STANDARDS_SCORE + 1))
        template_score=$((template_score + 1))
    else
        echo "⚠️  $(basename $dir): Missing"
    fi
done

# Security policy check
TOTAL_STANDARDS=$((TOTAL_STANDARDS + 1))
if [ -f "SECURITY.md" ] || [ -f ".github/SECURITY.md" ]; then
    echo "✅ Security policy: Present"
    STANDARDS_SCORE=$((STANDARDS_SCORE + 1))
else
    echo "⚠️  Security policy: Missing (SECURITY.md)"
fi

# Test coverage check
if [ -f "package.json" ] && command_exists "npm"; then
    echo "🧪 Checking test setup..."
    TOTAL_STANDARDS=$((TOTAL_STANDARDS + 1))
    
    if npm list --depth=0 | grep -E "(jest|mocha|vitest|cypress)" >/dev/null 2>&1; then
        echo "✅ Testing framework: Detected"
        STANDARDS_SCORE=$((STANDARDS_SCORE + 1))
        
        # Try to run tests and get coverage
        if npm run test >/dev/null 2>&1; then
            echo "  ✅ Tests: Passing"
        else
            echo "  ⚠️  Tests: Some tests failing"
        fi
    else
        echo "⚠️  Testing framework: Not detected"
    fi
fi

# License compliance check
if [ -f "LICENSE" ]; then
    echo "⚖️  Analyzing license compliance..."
    TOTAL_STANDARDS=$((TOTAL_STANDARDS + 1))
    
    # Check if license is a standard OSS license
    if grep -iE "(MIT|Apache|GPL|BSD|ISC)" LICENSE >/dev/null 2>&1; then
        echo "✅ License: Standard OSS license detected"
        STANDARDS_SCORE=$((STANDARDS_SCORE + 1))
    else
        echo "⚠️  License: Custom or non-standard license"
    fi
fi

# Dependency security check
if [ -f "package.json" ] && command_exists "npm"; then
    echo "🔒 Running security audit..."
    TOTAL_STANDARDS=$((TOTAL_STANDARDS + 1))
    
    if npm audit --audit-level moderate >/dev/null 2>&1; then
        echo "✅ Security: No moderate+ vulnerabilities"
        STANDARDS_SCORE=$((STANDARDS_SCORE + 1))
    else
        echo "⚠️  Security: Vulnerabilities detected - run 'npm audit' to see details"
    fi
fi

# Generate OSS health report
standards_percentage=$((STANDARDS_SCORE * 100 / TOTAL_STANDARDS))
echo ""
echo "🏆 OSS Health Score: $STANDARDS_SCORE/$TOTAL_STANDARDS ($standards_percentage%)"

# Save detailed report
cat > .claude/reports/oss-standards.json << EOF
{
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%S.%3NZ")",
  "score": $STANDARDS_SCORE,
  "total_standards": $TOTAL_STANDARDS,
  "percentage": $standards_percentage,
  "missing_files": $(printf '%s\n' "${missing_files[@]}" | jq -R . | jq -s .),
  "recommendations": [
    "Add missing essential files",
    "Improve documentation structure",
    "Set up automated testing",
    "Configure security scanning",
    "Add community templates"
  ]
}
EOF

# Provide specific recommendations
echo ""
echo "🎯 OSS Improvement Recommendations:"

if [ ${#missing_files[@]} -gt 0 ]; then
    echo "   📄 Add missing files: ${missing_files[*]}"
fi

if [ $standards_percentage -lt 70 ]; then
    echo "   🚀 Priority actions:"
    echo "      • Create comprehensive README with installation/usage sections"
    echo "      • Add proper LICENSE file"
    echo "      • Set up basic CI/CD with GitHub Actions"
    echo "      • Create CONTRIBUTING.md guidelines"
fi

if [ $standards_percentage -ge 70 ] && [ $standards_percentage -lt 90 ]; then
    echo "   ✨ Enhancement suggestions:"
    echo "      • Add issue and PR templates"
    echo "      • Improve test coverage"
    echo "      • Add security policy (SECURITY.md)"
    echo "      • Set up automated releases"
fi

if [ $standards_percentage -ge 90 ]; then
    echo "   🏆 Excellent OSS project! Consider:"
    echo "      • Documentation site (GitHub Pages, Docs)"
    echo "      • Advanced CI workflows (multi-platform testing)"
    echo "      • Community features (discussions, wiki)"
fi

echo "✅ OSS standards validation complete!"
exit 0