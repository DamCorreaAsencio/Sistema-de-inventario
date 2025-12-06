# 🚀 Guía de Inicio Rápido - Jenkins CI/CD

## ⚡ Instalación en 3 Pasos (10 minutos)

### Paso 1: Instalar Jenkins con Docker

**Windows:**
```cmd
cd "c:\Users\Carlos Ahumada Soles\OneDrive\Documentos\Proyecto_IaC\Sistema-de-inventario"
install-jenkins.bat
```

**Git Bash / WSL:**
```bash
cd "/c/Users/Carlos Ahumada Soles/OneDrive/Documentos/Proyecto_IaC/Sistema-de-inventario"
bash install-jenkins.sh
```

✅ **Resultado**: Jenkins corriendo en `http://localhost:8080`

---

### Paso 2: Configurar Jenkins

1. **Abrir**: `http://localhost:8080`
2. **Ingresar contraseña** (mostrada en el script)
3. **Instalar plugins sugeridos** (esperar ~5 min)
4. **Crear usuario admin**

#### Instalar plugins adicionales:
- `Manage Jenkins > Plugins > Available`
- Buscar e instalar:
  - **Docker Pipeline**
  - **Terraform**
  - **Blue Ocean** (opcional)

#### Configurar SonarCloud:
1. Ir a https://sonarcloud.io
2. Login con GitHub
3. Crear organización y proyecto
4. Generar token en: `My Account > Security > Generate Token`
5. En Jenkins: `Manage Jenkins > System > SonarQube servers`
   - Name: `SonarCloud`
   - URL: `https://sonarcloud.io`
   - Token: Agregar como credential `sonarcloud-token`

#### Configurar credenciales:
`Manage Jenkins > Credentials > Add`

- **aws-credentials** (AWS Credentials)
- **db-password** (Secret text)
- **sonarcloud-token** (Secret text)
- **git-credentials** (Username/password - si repo es privado)

---

### Paso 3: Crear Recursos AWS Mínimos

**Costo: ~$0.15/mes** (S3 + DynamoDB + ECR)

```bash
# Windows
create-aws-resources.bat

# Linux/Mac/Git Bash
bash create-aws-resources.sh
```

✅ **Crea**:
- S3 bucket para Terraform state
- DynamoDB table para state lock
- ECR repository para Docker images

---

## 🎯 Ejecutar Pipeline

### 1. Crear Pipeline Job

1. Jenkins: **"New Item"**
2. Nombre: `sistema-inventario-pipeline`
3. Tipo: **"Pipeline"**
4. Configurar:
   - Pipeline from SCM: **Git**
   - Repository URL: `<tu-repo>`
   - Branch: `*/main`
   - Script Path: `Jenkinsfile`

### 2. Actualizar Jenkinsfile

**IMPORTANTE**: Editar `Jenkinsfile` línea 125:
```groovy
-Dsonar.organization=<TU-ORGANIZACION> \
```
Reemplazar `<TU-ORGANIZACION>` con tu organización de SonarCloud.

### 3. Ejecutar

Click en **"Build Now"** 🚀

---

## 📊 Qué Hace el Pipeline

| Stage | Descripción | Tiempo |
|-------|-------------|--------|
| ✅ Checkout | Clona el código | 10s |
| ✅ Terraform Tests | Valida módulos | 2 min |
| ✅ Build Docker | Construye imagen | 3 min |
| ✅ App Tests | Tests unitarios | 1 min |
| ✅ SonarCloud | Análisis de calidad | 2 min |
| ✅ Checkov | Escaneo de seguridad | 1 min |
| ✅ Terraform Plan | Planifica cambios | 2 min |
| ⏸️ Terraform Apply | **COMENTADO** | - |

**Total**: ~12 minutos

⚠️ **NOTA**: Los stages de deploy (Terraform Apply) están **comentados** para evitar costos. El pipeline valida todo el código sin desplegar infraestructura real.

---

## 💰 Costos

### Actual (Solo testing)
- S3 bucket: $0.01/mes
- DynamoDB: $0 (free tier)
- ECR: $0.10/mes
- **Total: ~$0.15/mes**

### Si despliegas infraestructura completa
- VPC, subnets: $0
- RDS Multi-AZ: ~$30/mes
- ECS Fargate: ~$20/mes
- ALB: ~$20/mes
- CloudFront: ~$10/mes
- Otros: ~$20/mes
- **Total: ~$150-200/mes**

---

## 🔍 Ver Resultados

### Jenkins
- Classic UI: `http://localhost:8080/job/sistema-inventario-pipeline/`
- Blue Ocean: `http://localhost:8080/blue`

### SonarCloud
- Dashboard: `https://sonarcloud.io/dashboard?id=sistema-inventario`

### AWS
```bash
# Ver bucket
aws s3 ls s3://sistemainventario-terraform-state

# Ver imágenes Docker
aws ecr list-images --repository-name sistemainventario-backend --region us-east-2
```

---

## 🐛 Problemas Comunes

### Jenkins no inicia
```bash
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

## 📝 Próximos Pasos

1. ✅ Revisar reportes de SonarCloud
2. ✅ Revisar reportes de Checkov
3. ✅ Ajustar quality gates si es necesario
4. ⏸️ Cuando estés listo para deploy real:
   - Descomentar stages en Jenkinsfile
   - Ejecutar pipeline
   - Aprobar deployment

---

## 📚 Documentación Completa

- [LOCAL-SETUP.md](./LOCAL-SETUP.md) - Guía detallada de instalación
- [implementation_plan.md](../.gemini/antigravity/brain/.../implementation_plan.md) - Plan completo

---

## 🆘 Ayuda

Ver logs de Jenkins:
```bash
docker logs -f jenkins
```

Detener Jenkins:
```bash
docker-compose -f docker-compose.jenkins.yml down
```

Reiniciar Jenkins:
```bash
docker-compose -f docker-compose.jenkins.yml restart
```
