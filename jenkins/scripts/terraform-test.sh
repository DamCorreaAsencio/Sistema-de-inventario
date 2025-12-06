#!/bin/bash
# Terraform Unit Test Script
# Validates all Terraform modules individually

set -e

echo "======================================"
echo "🧪 Terraform Unit Tests"
echo "======================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

# Function to test a module
test_module() {
    local module_path=$1
    local module_name=$(basename $module_path)
    
    echo ""
    echo "Testing module: ${module_name}"
    echo "--------------------------------------"
    
    cd "$module_path"
    
    # Test 1: Terraform fmt
    echo "  ✓ Checking formatting..."
    if terraform fmt -check -diff; then
        echo -e "${GREEN}  ✅ Format check passed${NC}"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}  ❌ Format check failed${NC}"
        ((TESTS_FAILED++))
        return 1
    fi
    
    # Test 2: Terraform init
    echo "  ✓ Initializing..."
    if terraform init -backend=false > /dev/null 2>&1; then
        echo -e "${GREEN}  ✅ Init successful${NC}"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}  ❌ Init failed${NC}"
        ((TESTS_FAILED++))
        return 1
    fi
    
    # Test 3: Terraform validate
    echo "  ✓ Validating..."
    if terraform validate; then
        echo -e "${GREEN}  ✅ Validation passed${NC}"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}  ❌ Validation failed${NC}"
        ((TESTS_FAILED++))
        return 1
    fi
    
    cd - > /dev/null
    
    echo -e "${GREEN}✅ Module ${module_name} passed all tests${NC}"
    return 0
}

# Main execution
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"
TERRAFORM_DIR="${PROJECT_ROOT}/terraform"

cd "$TERRAFORM_DIR"

echo "Project root: $PROJECT_ROOT"
echo "Terraform directory: $TERRAFORM_DIR"
echo ""

# Test all modules
MODULES=(
    "modulos/vpc"
    "modulos/security_groups"
    "modulos/loadbalancer"
    "modulos/fargate"
    "modulos/rdsmulti"
    "modulos/apigateway"
    "modulos/cloudwatch"
    "modulos/waf"
    "modulos/cloudfront"
    "modulos/sns_sqs"
    "modulos/route53"
)

echo "Testing ${#MODULES[@]} modules..."
echo ""

for module in "${MODULES[@]}"; do
    if [ -d "$module" ]; then
        test_module "$module" || echo -e "${YELLOW}⚠️  Module $module had failures${NC}"
    else
        echo -e "${RED}❌ Module not found: $module${NC}"
        ((TESTS_FAILED++))
    fi
done

# Test main environment
echo ""
echo "Testing main environment configuration..."
echo "--------------------------------------"
test_module "envs/dev" || echo -e "${YELLOW}⚠️  Dev environment had failures${NC}"

# Summary
echo ""
echo "======================================"
echo "📊 Test Summary"
echo "======================================"
echo -e "Tests passed: ${GREEN}${TESTS_PASSED}${NC}"
echo -e "Tests failed: ${RED}${TESTS_FAILED}${NC}"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}❌ Some tests failed${NC}"
    exit 1
fi
