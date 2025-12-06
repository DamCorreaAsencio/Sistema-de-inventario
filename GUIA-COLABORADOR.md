# 🚀 Guía de Configuración Jenkins CI/CD - Para Colaboradores

## 📋 Prerrequisitos

Antes de empezar, asegúrate de tener instalado:

- ✅ **Docker Desktop** - https://www.docker.com/products/docker-desktop
- ✅ **Git** - https://git-scm.com/downloads
- ✅ **AWS CLI** - https://aws.amazon.com/cli/
- ✅ **Credenciales AWS** (Access Key ID y Secret Access Key)

---

## 🎯 Configuración Paso a Paso

### Paso 1: Clonar el Repositorio

```bash
git clone https://github.com/DamCorreaAsencio/Sistema-de-inventario.git
cd Sistema-de-inventario
git checkout pruebaJenkins
```

---

### Paso 2: Configurar AWS CLI

Abre PowerShell o CMD y ejecuta:

```powershell
aws configure
```

Ingresa tus credenciales:
- **AWS Access Key ID**: `<tu-access-key>`
- **AWS Secret Access Key**: `<tu-secret-key>`
- **Default region name**: `us-east-2`
- **Default output format**: `json`

**Verificar configuración:**
```powershell
aws sts get-caller-identity
```

Deberías ver:
```json
{
    "Account": "251740340893",  <-- Debe ser este Account ID
    "UserId": "...",
    "Arn": "..."
}
```

---

### Paso 3: Crear Recursos AWS Mínimos

Ejecuta el script para crear S3, DynamoDB y ECR:

**Windows:**
```powershell
cd Sistema-de-inventario
.\create-aws-resources.bat
```

**Linux/Mac:**
```bash
bash create-aws-resources.sh
```

**Costo:** ~$0.15/mes

**Recursos creados:**
- ✅ S3 bucket: `sistemainventario-terraform-state`
- ✅ DynamoDB table: `terraform-state-lock`
- ✅ ECR repository: `sistemainventario-backend`

---

### Paso 4: Instalar Jenkins con Docker

**Windows:**
```powershell
.\install-jenkins.bat
```

**Linux/Mac:**
```bash
bash install-jenkins.sh
```

**Espera ~2 minutos** mientras Jenkins inicia.

El script te mostrará:
- URL: `http://localhost:8080`
- Contraseña inicial de administrador

**Copia la contraseña** que aparece en la terminal.

---

### Paso 5: Configuración Inicial de Jenkins

1. **Abrir navegador**: `http://localhost:8080`

2. **Unlock Jenkins**:
   - Pega la contraseña inicial
   - Click "Continue"

3. **Customize Jenkins**:
   - Selecciona: **"Install suggested plugins"**
   - Espera ~5 minutos

4. **Create First Admin User**:
   - Username: `admin` (o el que prefieras)
   - Password: `<tu-contraseña-segura>`
   - Full name: `Tu Nombre`
   - Email: `tu@email.com`
   - Click "Save and Continue"

5. **Instance Configuration**:
   - Jenkins URL: `http://localhost:8080/`
   - Click "Save and Finish"

6. **Start using Jenkins**

---

### Paso 6: Instalar Plugins Adicionales

1. En Jenkins: **"Manage Jenkins"** → **"Plugins"** → **"Available plugins"**

2. Buscar e instalar (uno por uno en el buscador):
   - ✅ **Docker Pipeline** - Para construir imágenes Docker
   - ✅ **Terraform** - Para ejecutar Terraform
   - ✅ **CloudBees AWS Credentials** - Para credenciales AWS
   - ✅ **Pipeline: AWS Steps** - Para comandos AWS en pipeline
   - ✅ **Blue Ocean** (opcional) - Mejor visualización

3. Marcar todos los checkboxes y click **"Install"**

4. Marcar: **"Restart Jenkins when installation is complete"**

5. Esperar a que Jenkins se reinicie (~2 minutos)

---

### Paso 7: Configurar SonarCloud (Gratis)

1. **Crear cuenta**: https://sonarcloud.io
   - Login con GitHub
   - Autorizar acceso

2. **Crear organización**:
   - Usar tu username de GitHub
   - Click "Create organization"

3. **Crear proyecto**:
   - Click "+" → "Analyze new project"
   - Seleccionar repositorio: `Sistema-de-inventario`
   - Project key: `sistema-inventario`
   - Click "Set Up"

4. **Generar token**:
   - Avatar → "My Account" → "Security"
   - Generate Token:
     - Name: `jenkins-token`
     - Type: `User Token`
     - Expires: `No expiration`
   - **Copiar el token** (lo necesitarás en Jenkins)

5. **Copiar tu organización**:
   - En SonarCloud, arriba verás tu organización (ej: `tu-username`)
   - **Cópiala**, la necesitarás después

---

### Paso 8: Configurar SonarCloud en Jenkins

1. **Manage Jenkins** → **"System"**

2. Buscar **"SonarQube servers"** (scroll down)

3. Click **"Add SonarQube"**

4. Configurar:
   - **Name**: `SonarCloud`
   - **Server URL**: `https://sonarcloud.io`
   - **Server authentication token**: Click **"Add"** → **"Jenkins"**
     - Kind: `Secret text`
     - Secret: *pegar token de SonarCloud*
     - ID: `sonarcloud-token`
     - Description: `SonarCloud Token`
     - Click "Add"
   - Seleccionar el token recién creado

5. Click **"Save"**

---

### Paso 9: Configurar Credenciales AWS en Jenkins

1. **Manage Jenkins** → **"Credentials"** → **"System"** → **"Global credentials"** → **"Add Credentials"**

#### Credencial 1: AWS Credentials

- **Kind**: `AWS Credentials`
  - Si no aparece, usa `Username with password`:
    - Username: Tu Access Key ID
    - Password: Tu Secret Access Key
- **ID**: `aws-credentials`
- **Access Key ID**: `<tu-aws-access-key>`
- **Secret Access Key**: `<tu-aws-secret-key>`
- **Description**: `AWS Credentials`
- Click **"Create"**

#### Credencial 2: Database Password

- **Kind**: `Secret text`
- **Secret**: `Admin123456` (o la que prefieras para RDS)
- **ID**: `db-password`
- **Description**: `RDS Database Password`
- Click **"Create"**

---

### Paso 10: Actualizar Jenkinsfile con tu Organización de SonarCloud

1. Abrir archivo: `Jenkinsfile`

2. Buscar línea 125 (aproximadamente):
   ```groovy
   -Dsonar.organization=<TU-ORGANIZACION> \
   ```

3. Reemplazar `<TU-ORGANIZACION>` con tu organización de SonarCloud (la que copiaste en el Paso 7)

4. Guardar el archivo

5. Hacer commit:
   ```bash
   git add Jenkinsfile
   git commit -m "chore: update SonarCloud organization"
   git push origin pruebaJenkins
   ```

---

### Paso 11: Crear Pipeline Job en Jenkins

1. En Jenkins: Click **"New Item"**

2. Configurar:
   - **Name**: `sistema-inventario-pipeline`
   - **Type**: Selecciona **"Pipeline"**
   - Click **"OK"**

3. En la configuración del job:

   **General:**
   - Description: `CI/CD pipeline para Sistema de Inventario`
   - ✅ Discard old builds: Keep last 10 builds

   **Pipeline:**
   - Definition: **"Pipeline script from SCM"**
   - SCM: **"Git"**
   - Repository URL: `https://github.com/DamCorreaAsencio/Sistema-de-inventario.git`
   - Credentials: Dejar en blanco (repo público) o agregar credenciales Git si es privado
   - Branch Specifier: `*/pruebaJenkins`
   - Script Path: `Jenkinsfile`

4. Click **"Save"**

---

### Paso 12: Ejecutar el Pipeline

1. En el job `sistema-inventario-pipeline`, click **"Build Now"**

2. Ver progreso:
   - Vista clásica: Click en el número de build → "Console Output"
   - Blue Ocean: Click en "Open Blue Ocean" (menú lateral)

3. El pipeline ejecutará:
   - ✅ Checkout del código
   - ✅ Tests de Terraform
   - ✅ Build de Docker image
   - ✅ Tests de aplicación
   - ✅ Análisis de SonarCloud
   - ✅ Escaneo de seguridad (Checkov)
   - ✅ Terraform Plan
   - ⏸️ **Terraform Apply está COMENTADO** (no desplegará infraestructura)

**Duración:** ~12-15 minutos

---

## 📊 Revisar Resultados

### SonarCloud
- Ve a: https://sonarcloud.io/dashboard?id=sistema-inventario
- Revisa métricas de calidad de código

### Jenkins
- Revisa logs de cada stage
- Verifica que todos los stages pasen ✅

### AWS
```powershell
# Ver bucket S3
aws s3 ls s3://sistemainventario-terraform-state

# Ver imágenes Docker en ECR
aws ecr list-images --repository-name sistemainventario-backend --region us-east-2
```

---

## 🚀 Desplegar Infraestructura Real (Opcional)

⚠️ **IMPORTANTE**: Esto desplegará infraestructura real en AWS con costo de ~$150-200/mes

1. Editar `Jenkinsfile`
2. Descomentar los stages:
   - `Terraform Apply` (línea ~310)
   - `Deploy Validation` (línea ~340)
3. Commit y push
4. Ejecutar pipeline
5. Aprobar deployment manualmente cuando se solicite

---

## 🐛 Troubleshooting

### Jenkins no inicia
```powershell
docker logs jenkins
docker-compose -f docker-compose.jenkins.yml restart
```

### Pipeline falla en "Checkout"
- Verificar URL del repositorio
- Verificar credenciales Git (si es privado)

### Pipeline falla en "Build Docker"
- Verificar credenciales AWS
- Verificar que ECR repository existe

### Pipeline falla en "SonarCloud"
- Verificar token de SonarCloud
- Verificar organización en Jenkinsfile
- Verificar que el proyecto existe en SonarCloud

---

## 📞 Comandos Útiles

```powershell
# Ver logs de Jenkins
docker logs -f jenkins

# Detener Jenkins
docker-compose -f docker-compose.jenkins.yml down

# Iniciar Jenkins
docker-compose -f docker-compose.jenkins.yml up -d

# Reiniciar Jenkins
docker-compose -f docker-compose.jenkins.yml restart

# Ver contraseña inicial (si la perdiste)
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

---

## 💰 Costos AWS

### Actual (Solo testing):
- S3 bucket: $0.01/mes
- DynamoDB: $0 (free tier)
- ECR: $0.10/mes
- **Total: ~$0.15/mes**

### Con infraestructura completa:
- RDS Multi-AZ: ~$30/mes
- ECS Fargate: ~$20/mes
- ALB: ~$20/mes
- CloudFront: ~$10/mes
- Otros: ~$20/mes
- **Total: ~$150-200/mes**

---

## ✅ Checklist de Verificación

- [ ] Docker Desktop instalado y corriendo
- [ ] AWS CLI configurado con credenciales correctas
- [ ] Recursos AWS creados (S3, DynamoDB, ECR)
- [ ] Jenkins instalado y corriendo
- [ ] Plugins instalados (Docker Pipeline, Terraform)
- [ ] SonarCloud configurado
- [ ] Credenciales configuradas en Jenkins (AWS, DB password, SonarCloud)
- [ ] Jenkinsfile actualizado con organización de SonarCloud
- [ ] Pipeline job creado en Jenkins
- [ ] Pipeline ejecutado exitosamente

---

## 🎓 Recursos Adicionales

- **Documentación completa**: Ver carpeta `jenkins/`
- **Plan de implementación**: Ver `.gemini/antigravity/brain/.../implementation_plan.md`
- **Guía local**: `jenkins/LOCAL-SETUP.md`

---

**¿Problemas?** Revisa los logs y la documentación en la carpeta `jenkins/`.
