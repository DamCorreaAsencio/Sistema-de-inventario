# Guía de Instalación Jenkins Local con Docker

## 🚀 Instalación Rápida

### Opción 1: Script Automático (Recomendado)

**Windows (PowerShell o CMD):**
```cmd
install-jenkins.bat
```

**Git Bash / WSL:**
```bash
bash install-jenkins.sh
```

### Opción 2: Manual

```bash
# Iniciar Jenkins
docker-compose -f docker-compose.jenkins.yml up -d

# Ver contraseña inicial
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

---

## 📋 Configuración Inicial

### 1. Acceder a Jenkins

1. Abre: `http://localhost:8080`
2. Ingresa la contraseña inicial (mostrada en el script)
3. Selecciona: **"Install suggested plugins"**
4. Espera a que se instalen los plugins (~5 minutos)
5. Crea tu usuario administrador

### 2. Instalar Plugins Adicionales

`Manage Jenkins > Plugins > Available plugins`

Buscar e instalar:
- ✅ **Pipeline** (ya instalado)
- ✅ **Git** (ya instalado)
- ✅ **Docker Pipeline**
- ✅ **Terraform**
- ✅ **Blue Ocean** (opcional, mejor UI)

Click en **"Install"** y esperar.

### 3. Configurar SonarCloud (Gratis)

#### 3.1 Crear cuenta en SonarCloud

1. Ir a: https://sonarcloud.io
2. Click en **"Log in"** → **"Sign up with GitHub"** (o GitLab/Bitbucket)
3. Autorizar acceso
4. Crear organización (usar tu nombre de usuario de GitHub)

#### 3.2 Crear proyecto en SonarCloud

1. En SonarCloud: **"+"** → **"Analyze new project"**
2. Seleccionar tu repositorio (o crear manualmente)
3. Project key: `sistema-inventario`
4. Click en **"Set Up"**

#### 3.3 Generar Token

1. En SonarCloud: Click en tu avatar → **"My Account"** → **"Security"**
2. Generate Token:
   - Name: `jenkins-token`
   - Type: `User Token`
   - Expires in: `No expiration`
3. **Copiar el token** (lo necesitarás en Jenkins)

#### 3.4 Configurar en Jenkins

1. `Manage Jenkins > System > SonarQube servers`
2. Click **"Add SonarQube"**
3. Configurar:
   - Name: `SonarCloud`
   - Server URL: `https://sonarcloud.io`
   - Server authentication token: Click **"Add"** → **"Jenkins"**
     - Kind: `Secret text`
     - Secret: *pegar token de SonarCloud*
     - ID: `sonarcloud-token`
     - Description: `SonarCloud Token`
   - Click **"Add"** y seleccionar el token creado
4. Click **"Save"**

### 4. Configurar Credenciales AWS

`Manage Jenkins > Credentials > System > Global credentials > Add Credentials`

#### 4.1 AWS Credentials

- Kind: `AWS Credentials`
- ID: `aws-credentials`
- Access Key ID: `<tu-access-key>`
- Secret Access Key: `<tu-secret-key>`
- Description: `AWS Credentials for Terraform`

#### 4.2 Database Password

- Kind: `Secret text`
- Secret: `<tu-contraseña-rds>`
- ID: `db-password`
- Description: `RDS Database Password`

#### 4.3 Git Credentials (si tu repo es privado)

- Kind: `Username with password`
- Username: `<tu-usuario-git>`
- Password: `<tu-token-git>`
- ID: `git-credentials`
- Description: `Git Repository Access`

---

## 🔧 Crear Recursos AWS Mínimos

### S3 Bucket para Terraform State (Costo: ~$0.01/mes)

```bash
# Crear bucket
aws s3api create-bucket \
    --bucket sistemainventario-terraform-state \
    --region us-east-2 \
    --create-bucket-configuration LocationConstraint=us-east-2

# Habilitar versionado
aws s3api put-bucket-versioning \
    --bucket sistemainventario-terraform-state \
    --versioning-configuration Status=Enabled

# Habilitar encriptación
aws s3api put-bucket-encryption \
    --bucket sistemainventario-terraform-state \
    --server-side-encryption-configuration '{
        "Rules": [{
            "ApplyServerSideEncryptionByDefault": {
                "SSEAlgorithm": "AES256"
            }
        }]
    }'
```

### DynamoDB Table para State Lock (Costo: ~$0/mes con free tier)

```bash
aws dynamodb create-table \
    --table-name terraform-state-lock \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region us-east-2
```

### ECR Repository para Docker Images (Costo: ~$0.10/mes)

```bash
aws ecr create-repository \
    --repository-name sistemainventario-backend \
    --region us-east-2 \
    --image-scanning-configuration scanOnPush=true
```

**Costo total estimado: ~$0.15/mes** (prácticamente gratis)

---

## 🎯 Crear Pipeline Job en Jenkins

### 1. Crear Job

1. En Jenkins: Click **"New Item"**
2. Nombre: `sistema-inventario-pipeline`
3. Tipo: **"Pipeline"**
4. Click **"OK"**

### 2. Configurar Pipeline

**General:**
- Description: `CI/CD pipeline para Sistema de Inventario`
- ✅ **Discard old builds**: Keep last 10 builds

**Pipeline:**
- Definition: **"Pipeline script from SCM"**
- SCM: **"Git"**
- Repository URL: `<url-de-tu-repositorio>`
- Credentials: Seleccionar `git-credentials` (si es privado)
- Branch Specifier: `*/main` (o `*/develop`)
- Script Path: `Jenkinsfile`

**Build Triggers (opcional):**
- ✅ Poll SCM: `H/5 * * * *` (cada 5 minutos)

Click **"Save"**

---

## ✅ Verificar Instalación

### 1. Verificar Jenkins

```bash
# Ver logs
docker logs -f jenkins

# Verificar que está corriendo
docker ps | grep jenkins
```

### 2. Verificar Plugins

`Manage Jenkins > Plugins > Installed plugins`

Verificar que estén instalados:
- Pipeline
- Git
- Docker Pipeline
- Terraform

### 3. Verificar Credenciales

`Manage Jenkins > Credentials`

Verificar que existan:
- aws-credentials
- db-password
- sonarcloud-token
- git-credentials (si aplica)

### 4. Verificar SonarCloud

`Manage Jenkins > System > SonarQube servers`

Verificar que esté configurado `SonarCloud`

---

## 🧪 Probar Pipeline (Sin Deploy)

### Modificar Jenkinsfile para Testing

Comentar temporalmente el stage de Terraform Apply:

```groovy
// Comentar este stage para pruebas iniciales
/*
stage('Terraform Apply') {
    // ...
}
*/
```

### Ejecutar Pipeline

1. Ir al job: `sistema-inventario-pipeline`
2. Click **"Build Now"**
3. Ver progreso en **"Blue Ocean"** o en la vista clásica
4. Revisar logs de cada stage

---

## 🐛 Troubleshooting

### Jenkins no inicia

```bash
# Ver logs
docker logs jenkins

# Reiniciar
docker-compose -f docker-compose.jenkins.yml restart
```

### No puedo acceder a http://localhost:8080

```bash
# Verificar que el puerto no esté ocupado
netstat -ano | findstr :8080

# Cambiar puerto en docker-compose.jenkins.yml si es necesario
# ports:
#   - "8081:8080"  # Usar 8081 en lugar de 8080
```

### Error de permisos con Docker

En Windows con WSL2, asegúrate de que Docker Desktop esté corriendo.

### Pipeline falla en "Checkout"

Verificar:
- URL del repositorio es correcta
- Credenciales Git configuradas (si es privado)
- Branch existe

---

## 📊 Monitoreo

### Ver logs de Jenkins

```bash
docker logs -f jenkins
```

### Acceder a Jenkins CLI

```bash
docker exec -it jenkins bash
```

### Ver uso de recursos

```bash
docker stats jenkins
```

---

## 🔄 Comandos Útiles

```bash
# Iniciar Jenkins
docker-compose -f docker-compose.jenkins.yml up -d

# Detener Jenkins
docker-compose -f docker-compose.jenkins.yml down

# Reiniciar Jenkins
docker-compose -f docker-compose.jenkins.yml restart

# Ver logs
docker logs -f jenkins

# Backup de Jenkins
docker cp jenkins:/var/jenkins_home ./jenkins-backup

# Restaurar Jenkins
docker cp ./jenkins-backup/. jenkins:/var/jenkins_home
```

---

## 🎓 Próximos Pasos

1. ✅ Ejecutar pipeline de prueba
2. ✅ Revisar reportes de SonarCloud
3. ✅ Revisar reportes de Checkov
4. ✅ Ajustar configuraciones según necesidad
5. ⏸️ Cuando estés listo, descomentar Terraform Apply para deploy real

---

## 💰 Costos AWS (Solo recursos mínimos)

| Recurso | Costo/mes |
|---------|-----------|
| S3 Bucket (state) | ~$0.01 |
| DynamoDB (lock) | $0 (free tier) |
| ECR (imágenes) | ~$0.10 |
| **TOTAL** | **~$0.15/mes** |

**Nota:** NO estamos levantando la infraestructura completa (EC2, RDS, ALB, etc.) hasta que estés listo.
