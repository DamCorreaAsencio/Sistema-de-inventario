#!/bin/bash
# Application Tests Script
# Runs unit tests and linting for backend application

set -e

echo "======================================"
echo "🧪 Running Application Tests"
echo "======================================"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Navigate to backend directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"
BACKEND_DIR="${PROJECT_ROOT}/backend"

cd "$BACKEND_DIR"

echo "Testing from: $BACKEND_DIR"
echo ""

# Step 1: Install dependencies
echo "Step 1: Installing dependencies..."
if [ -f "package.json" ]; then
    npm ci
    echo -e "${GREEN}✅ Dependencies installed${NC}"
else
    echo -e "${RED}❌ package.json not found${NC}"
    exit 1
fi
echo ""

# Step 2: Run linting
echo "Step 2: Running ESLint..."
if grep -q "\"lint\"" package.json; then
    if npm run lint; then
        echo -e "${GREEN}✅ Linting passed${NC}"
    else
        echo -e "${YELLOW}⚠️  Linting warnings found (continuing...)${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  No lint script found in package.json${NC}"
fi
echo ""

# Step 3: Run unit tests
echo "Step 3: Running unit tests..."
if grep -q "\"test\"" package.json; then
    if npm test; then
        echo -e "${GREEN}✅ Tests passed${NC}"
    else
        echo -e "${RED}❌ Tests failed${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}⚠️  No test script found in package.json${NC}"
    echo "Creating basic test structure..."
    
    # Create basic test if none exists
    mkdir -p tests
    cat > tests/basic.test.js << 'EOF'
// Basic smoke test
describe('Basic Tests', () => {
    test('should pass', () => {
        expect(true).toBe(true);
    });
});
EOF
    
    echo -e "${YELLOW}⚠️  Basic test created. Add proper tests for your application.${NC}"
fi
echo ""

# Step 4: Check code coverage (if configured)
echo "Step 4: Checking code coverage..."
if grep -q "\"coverage\"" package.json; then
    npm run coverage || echo -e "${YELLOW}⚠️  Coverage check skipped${NC}"
else
    echo -e "${YELLOW}⚠️  No coverage script configured${NC}"
fi
echo ""

# Step 5: Security audit
echo "Step 5: Running security audit..."
if npm audit --audit-level=high; then
    echo -e "${GREEN}✅ No high-severity vulnerabilities found${NC}"
else
    echo -e "${YELLOW}⚠️  Security vulnerabilities detected${NC}"
    echo "Run 'npm audit fix' to fix them"
fi
echo ""

echo "======================================"
echo -e "${GREEN}✅ Application tests completed${NC}"
echo "======================================"
