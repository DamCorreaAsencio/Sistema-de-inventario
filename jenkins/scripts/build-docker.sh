#!/bin/bash
# Docker Build and Push Script
# Builds backend Docker image and pushes to AWS ECR

set -e

echo "======================================"
echo "🐳 Docker Build & Push"
echo "======================================"

# Configuration
AWS_REGION="${AWS_REGION:-us-east-2}"
AWS_ACCOUNT_ID="${AWS_ACCOUNT_ID:-251740340893}"
ECR_REPO="${ECR_REPO:-sistemainventario-backend}"
IMAGE_TAG="${IMAGE_TAG:-latest}"
GIT_COMMIT="${GIT_COMMIT:-$(git rev-parse --short HEAD)}"
BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ')

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "Configuration:"
echo "  AWS Region: $AWS_REGION"
echo "  AWS Account: $AWS_ACCOUNT_ID"
echo "  ECR Repository: $ECR_REPO"
echo "  Image Tag: $IMAGE_TAG"
echo "  Git Commit: $GIT_COMMIT"
echo ""

# Navigate to backend directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"
BACKEND_DIR="${PROJECT_ROOT}/backend"

cd "$BACKEND_DIR"

echo "Building from: $BACKEND_DIR"
echo ""

# Step 1: Login to ECR
echo "Step 1: Logging in to AWS ECR..."
aws ecr get-login-password --region "$AWS_REGION" | \
    docker login --username AWS --password-stdin \
    "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

echo -e "${GREEN}✅ ECR login successful${NC}"
echo ""

# Step 2: Build Docker image
echo "Step 2: Building Docker image..."
docker build \
    -t "${ECR_REPO}:${IMAGE_TAG}" \
    -t "${ECR_REPO}:${GIT_COMMIT}" \
    -t "${ECR_REPO}:latest" \
    --build-arg BUILD_DATE="${BUILD_DATE}" \
    --build-arg VCS_REF="${GIT_COMMIT}" \
    --build-arg VERSION="${IMAGE_TAG}" \
    .

echo -e "${GREEN}✅ Docker image built successfully${NC}"
echo ""

# Step 3: Tag images for ECR
echo "Step 3: Tagging images for ECR..."
docker tag "${ECR_REPO}:${IMAGE_TAG}" \
    "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${IMAGE_TAG}"

docker tag "${ECR_REPO}:${GIT_COMMIT}" \
    "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${GIT_COMMIT}"

docker tag "${ECR_REPO}:latest" \
    "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:latest"

echo -e "${GREEN}✅ Images tagged${NC}"
echo ""

# Step 4: Push to ECR
echo "Step 4: Pushing images to ECR..."
docker push "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${IMAGE_TAG}"
docker push "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${GIT_COMMIT}"
docker push "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:latest"

echo -e "${GREEN}✅ Images pushed to ECR${NC}"
echo ""

# Step 5: Display image information
echo "======================================"
echo "📦 Image Information"
echo "======================================"
echo "Repository: ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}"
echo "Tags:"
echo "  - ${IMAGE_TAG}"
echo "  - ${GIT_COMMIT}"
echo "  - latest"
echo ""

# Step 6: Cleanup local images (optional)
echo "Cleaning up local images..."
docker rmi "${ECR_REPO}:${IMAGE_TAG}" || true
docker rmi "${ECR_REPO}:${GIT_COMMIT}" || true
docker rmi "${ECR_REPO}:latest" || true

echo -e "${GREEN}✅ Build and push completed successfully!${NC}"
