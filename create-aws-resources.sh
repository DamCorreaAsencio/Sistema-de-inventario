#!/bin/bash
# Script para crear recursos AWS mínimos
# Solo S3, DynamoDB y ECR - Costo: ~$0.15/mes

set -e

echo "======================================"
echo "☁️  Creando Recursos AWS Mínimos"
echo "======================================"
echo ""

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Configuración
AWS_REGION="us-east-2"
S3_BUCKET="sistemainventario-terraform-state"
DYNAMODB_TABLE="terraform-state-lock"
ECR_REPO="sistemainventario-backend"

# Verificar AWS CLI
echo "Verificando AWS CLI..."
if ! command -v aws &> /dev/null; then
    echo -e "${RED}❌ AWS CLI no está instalado${NC}"
    echo "Instala AWS CLI desde: https://aws.amazon.com/cli/"
    exit 1
fi

# Verificar credenciales
echo "Verificando credenciales AWS..."
if ! aws sts get-caller-identity &> /dev/null; then
    echo -e "${RED}❌ Credenciales AWS no configuradas${NC}"
    echo "Ejecuta: aws configure"
    exit 1
fi

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
echo -e "${GREEN}✅ Conectado a AWS Account: $ACCOUNT_ID${NC}"
echo ""

# Crear S3 Bucket
echo "1. Creando S3 Bucket para Terraform State..."
if aws s3api head-bucket --bucket "$S3_BUCKET" 2>/dev/null; then
    echo -e "${YELLOW}⚠️  Bucket ya existe: $S3_BUCKET${NC}"
else
    aws s3api create-bucket \
        --bucket "$S3_BUCKET" \
        --region "$AWS_REGION" \
        --create-bucket-configuration LocationConstraint="$AWS_REGION"
    
    echo "   Habilitando versionado..."
    aws s3api put-bucket-versioning \
        --bucket "$S3_BUCKET" \
        --versioning-configuration Status=Enabled
    
    echo "   Habilitando encriptación..."
    aws s3api put-bucket-encryption \
        --bucket "$S3_BUCKET" \
        --server-side-encryption-configuration '{
            "Rules": [{
                "ApplyServerSideEncryptionByDefault": {
                    "SSEAlgorithm": "AES256"
                }
            }]
        }'
    
    echo -e "${GREEN}   ✅ S3 Bucket creado: $S3_BUCKET${NC}"
fi
echo ""

# Crear DynamoDB Table
echo "2. Creando DynamoDB Table para State Lock..."
if aws dynamodb describe-table --table-name "$DYNAMODB_TABLE" --region "$AWS_REGION" &>/dev/null; then
    echo -e "${YELLOW}⚠️  Tabla ya existe: $DYNAMODB_TABLE${NC}"
else
    aws dynamodb create-table \
        --table-name "$DYNAMODB_TABLE" \
        --attribute-definitions AttributeName=LockID,AttributeType=S \
        --key-schema AttributeName=LockID,KeyType=HASH \
        --billing-mode PAY_PER_REQUEST \
        --region "$AWS_REGION"
    
    echo "   Esperando a que la tabla esté activa..."
    aws dynamodb wait table-exists --table-name "$DYNAMODB_TABLE" --region "$AWS_REGION"
    
    echo -e "${GREEN}   ✅ DynamoDB Table creada: $DYNAMODB_TABLE${NC}"
fi
echo ""

# Crear ECR Repository
echo "3. Creando ECR Repository para Docker Images..."
if aws ecr describe-repositories --repository-names "$ECR_REPO" --region "$AWS_REGION" &>/dev/null; then
    echo -e "${YELLOW}⚠️  Repositorio ya existe: $ECR_REPO${NC}"
else
    aws ecr create-repository \
        --repository-name "$ECR_REPO" \
        --region "$AWS_REGION" \
        --image-scanning-configuration scanOnPush=true \
        --encryption-configuration encryptionType=AES256
    
    echo -e "${GREEN}   ✅ ECR Repository creado: $ECR_REPO${NC}"
fi
echo ""

# Resumen
echo "======================================"
echo "📊 Resumen de Recursos Creados"
echo "======================================"
echo ""
echo "✅ S3 Bucket: s3://$S3_BUCKET"
echo "✅ DynamoDB Table: $DYNAMODB_TABLE"
echo "✅ ECR Repository: $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO"
echo ""
echo "Región: $AWS_REGION"
echo "Account ID: $ACCOUNT_ID"
echo ""
echo "💰 Costo estimado: ~\$0.15/mes"
echo ""
echo -e "${GREEN}✅ Recursos AWS creados exitosamente${NC}"
echo ""
echo "Próximos pasos:"
echo "1. Configurar credenciales AWS en Jenkins"
echo "2. Ejecutar pipeline de prueba"
echo ""
