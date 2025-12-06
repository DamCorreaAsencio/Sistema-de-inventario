@echo off
REM Script para crear recursos AWS mínimos (Windows)
REM Solo S3, DynamoDB y ECR - Costo: ~$0.15/mes

echo ======================================
echo Creando Recursos AWS Minimos
echo ======================================
echo.

REM Configuración
set AWS_REGION=us-east-2
set S3_BUCKET=sistemainventario-terraform-state
set DYNAMODB_TABLE=terraform-state-lock
set ECR_REPO=sistemainventario-backend

REM Verificar AWS CLI
echo Verificando AWS CLI...
aws --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] AWS CLI no esta instalado
    echo Instala AWS CLI desde: https://aws.amazon.com/cli/
    pause
    exit /b 1
)

REM Verificar credenciales
echo Verificando credenciales AWS...
aws sts get-caller-identity >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Credenciales AWS no configuradas
    echo Ejecuta: aws configure
    pause
    exit /b 1
)

for /f "tokens=*" %%a in ('aws sts get-caller-identity --query Account --output text') do set ACCOUNT_ID=%%a
echo [OK] Conectado a AWS Account: %ACCOUNT_ID%
echo.

REM Crear S3 Bucket
echo 1. Creando S3 Bucket para Terraform State...
aws s3api head-bucket --bucket %S3_BUCKET% 2>nul
if %errorlevel% equ 0 (
    echo [WARN] Bucket ya existe: %S3_BUCKET%
) else (
    aws s3api create-bucket --bucket %S3_BUCKET% --region %AWS_REGION% --create-bucket-configuration LocationConstraint=%AWS_REGION%
    
    echo    Habilitando versionado...
    aws s3api put-bucket-versioning --bucket %S3_BUCKET% --versioning-configuration Status=Enabled
    
    echo    Habilitando encriptacion...
    aws s3api put-bucket-encryption --bucket %S3_BUCKET% --server-side-encryption-configuration "{\"Rules\":[{\"ApplyServerSideEncryptionByDefault\":{\"SSEAlgorithm\":\"AES256\"}}]}"
    
    echo    [OK] S3 Bucket creado: %S3_BUCKET%
)
echo.

REM Crear DynamoDB Table
echo 2. Creando DynamoDB Table para State Lock...
aws dynamodb describe-table --table-name %DYNAMODB_TABLE% --region %AWS_REGION% >nul 2>&1
if %errorlevel% equ 0 (
    echo [WARN] Tabla ya existe: %DYNAMODB_TABLE%
) else (
    aws dynamodb create-table --table-name %DYNAMODB_TABLE% --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --billing-mode PAY_PER_REQUEST --region %AWS_REGION%
    
    echo    Esperando a que la tabla este activa...
    aws dynamodb wait table-exists --table-name %DYNAMODB_TABLE% --region %AWS_REGION%
    
    echo    [OK] DynamoDB Table creada: %DYNAMODB_TABLE%
)
echo.

REM Crear ECR Repository
echo 3. Creando ECR Repository para Docker Images...
aws ecr describe-repositories --repository-names %ECR_REPO% --region %AWS_REGION% >nul 2>&1
if %errorlevel% equ 0 (
    echo [WARN] Repositorio ya existe: %ECR_REPO%
) else (
    aws ecr create-repository --repository-name %ECR_REPO% --region %AWS_REGION% --image-scanning-configuration scanOnPush=true --encryption-configuration encryptionType=AES256
    
    echo    [OK] ECR Repository creado: %ECR_REPO%
)
echo.

REM Resumen
echo ======================================
echo Resumen de Recursos Creados
echo ======================================
echo.
echo [OK] S3 Bucket: s3://%S3_BUCKET%
echo [OK] DynamoDB Table: %DYNAMODB_TABLE%
echo [OK] ECR Repository: %ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com/%ECR_REPO%
echo.
echo Region: %AWS_REGION%
echo Account ID: %ACCOUNT_ID%
echo.
echo Costo estimado: ~$0.15/mes
echo.
echo [OK] Recursos AWS creados exitosamente
echo.
echo Proximos pasos:
echo 1. Configurar credenciales AWS en Jenkins
echo 2. Ejecutar pipeline de prueba
echo.
pause
