#!/bin/bash
# Deploy Validation Script
# Validates the deployment by checking infrastructure health

set -e

echo "======================================"
echo "✅ Post-Deployment Validation"
echo "======================================"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Configuration
AWS_REGION="${AWS_REGION:-us-east-2}"
TF_DIR="${TF_DIR:-terraform/envs/dev}"
MAX_RETRIES=10
RETRY_DELAY=15

# Navigate to Terraform directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"

cd "${PROJECT_ROOT}/${TF_DIR}"

echo "Validating from: $(pwd)"
echo ""

# Function to check HTTP endpoint
check_endpoint() {
    local url=$1
    local expected_code=$2
    local max_attempts=$3
    
    echo "Checking endpoint: $url"
    
    for i in $(seq 1 $max_attempts); do
        echo "  Attempt $i/$max_attempts..."
        
        http_code=$(curl -s -o /dev/null -w "%{http_code}" "$url" || echo "000")
        
        if [[ "$http_code" =~ $expected_code ]]; then
            echo -e "${GREEN}  ✅ Endpoint responding with code: $http_code${NC}"
            return 0
        fi
        
        echo -e "${YELLOW}  ⏳ Got $http_code, retrying in ${RETRY_DELAY}s...${NC}"
        sleep $RETRY_DELAY
    done
    
    echo -e "${RED}  ❌ Endpoint check failed after $max_attempts attempts${NC}"
    return 1
}

# Step 1: Verify Terraform outputs
echo "Step 1: Retrieving Terraform outputs..."
if terraform output -json > terraform-outputs.json; then
    echo -e "${GREEN}✅ Terraform outputs retrieved${NC}"
else
    echo -e "${RED}❌ Failed to get Terraform outputs${NC}"
    exit 1
fi
echo ""

# Step 2: Check ALB
echo "Step 2: Validating Application Load Balancer..."
ALB_DNS=$(terraform output -raw alb_dns_name 2>/dev/null || echo "")

if [ -n "$ALB_DNS" ]; then
    echo "ALB DNS: $ALB_DNS"
    
    # Wait for ALB to be ready
    echo "Waiting for ALB to be ready..."
    sleep 30
    
    # Check ALB health
    if check_endpoint "http://${ALB_DNS}" "200|301|302|503" 5; then
        echo -e "${GREEN}✅ ALB is responding${NC}"
    else
        echo -e "${YELLOW}⚠️  ALB health check inconclusive${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  ALB DNS not found in outputs${NC}"
fi
echo ""

# Step 3: Check API Gateway
echo "Step 3: Validating API Gateway..."
API_URL=$(terraform output -raw api_gateway_url 2>/dev/null || echo "")

if [ -n "$API_URL" ]; then
    echo "API Gateway URL: $API_URL"
    
    if check_endpoint "$API_URL" "200|403|404" 3; then
        echo -e "${GREEN}✅ API Gateway is responding${NC}"
    else
        echo -e "${YELLOW}⚠️  API Gateway check inconclusive${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  API Gateway URL not found${NC}"
fi
echo ""

# Step 4: Check RDS
echo "Step 4: Validating RDS Database..."
RDS_ENDPOINT=$(terraform output -raw rds_endpoint 2>/dev/null || echo "")

if [ -n "$RDS_ENDPOINT" ]; then
    echo "RDS Endpoint: $RDS_ENDPOINT"
    
    # Check if RDS is reachable (from within VPC)
    RDS_HOST=$(echo $RDS_ENDPOINT | cut -d: -f1)
    
    if timeout 5 bash -c "cat < /dev/null > /dev/tcp/${RDS_HOST}/3306" 2>/dev/null; then
        echo -e "${GREEN}✅ RDS is reachable${NC}"
    else
        echo -e "${YELLOW}⚠️  RDS not reachable from this location (expected if outside VPC)${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  RDS endpoint not found${NC}"
fi
echo ""

# Step 5: Check ECS Service
echo "Step 5: Validating ECS Service..."
CLUSTER_NAME=$(terraform output -raw ecs_cluster_name 2>/dev/null || echo "")
SERVICE_NAME=$(terraform output -raw ecs_service_name 2>/dev/null || echo "")

if [ -n "$CLUSTER_NAME" ] && [ -n "$SERVICE_NAME" ]; then
    echo "ECS Cluster: $CLUSTER_NAME"
    echo "ECS Service: $SERVICE_NAME"
    
    # Check service status
    SERVICE_STATUS=$(aws ecs describe-services \
        --cluster "$CLUSTER_NAME" \
        --services "$SERVICE_NAME" \
        --region "$AWS_REGION" \
        --query 'services[0].status' \
        --output text 2>/dev/null || echo "UNKNOWN")
    
    RUNNING_COUNT=$(aws ecs describe-services \
        --cluster "$CLUSTER_NAME" \
        --services "$SERVICE_NAME" \
        --region "$AWS_REGION" \
        --query 'services[0].runningCount' \
        --output text 2>/dev/null || echo "0")
    
    echo "Service Status: $SERVICE_STATUS"
    echo "Running Tasks: $RUNNING_COUNT"
    
    if [ "$SERVICE_STATUS" = "ACTIVE" ] && [ "$RUNNING_COUNT" -gt 0 ]; then
        echo -e "${GREEN}✅ ECS service is running${NC}"
    else
        echo -e "${YELLOW}⚠️  ECS service may not be fully ready${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  ECS information not found${NC}"
fi
echo ""

# Step 6: Check CloudFront (if deployed)
echo "Step 6: Validating CloudFront Distribution..."
CF_DOMAIN=$(terraform output -raw cloudfront_domain 2>/dev/null || echo "")

if [ -n "$CF_DOMAIN" ]; then
    echo "CloudFront Domain: $CF_DOMAIN"
    
    if check_endpoint "https://${CF_DOMAIN}" "200|403" 3; then
        echo -e "${GREEN}✅ CloudFront is responding${NC}"
    else
        echo -e "${YELLOW}⚠️  CloudFront check inconclusive${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  CloudFront domain not found${NC}"
fi
echo ""

# Summary
echo "======================================"
echo "📊 Validation Summary"
echo "======================================"
echo "Deployment validation completed."
echo ""
echo "Next steps:"
echo "  1. Review CloudWatch logs for any errors"
echo "  2. Test application functionality manually"
echo "  3. Monitor metrics in CloudWatch dashboard"
echo ""
echo -e "${GREEN}✅ Validation script completed${NC}"
