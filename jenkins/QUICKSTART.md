# Quick Start Guide - Jenkins CI/CD Pipeline

## 🚀 Inicio Rápido (5 minutos)

### 1. Instalar Jenkins

**Opción rápida con Docker:**
```bash
docker run -d -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  --name jenkins jenkins/jenkins:lts

# Obtener contraseña inicial
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

Acceder a: `http://localhost:8080`

### 2. Instalar Plugins Esenciales

En Jenkins UI:
1. Ir a `Manage Jenkins > Plugins`
2. Instalar:
   - Pipeline
   - Git
   - Docker Pipeline
   - AWS Credentials
   - Terraform
   - SonarQube Scanner

### 3. Configurar Credenciales

`Manage Jenkins > Credentials > Add Credentials`

Crear:
- **aws-credentials**: AWS Access Key
- **db-password**: Contraseña de RDS
- **git-credentials**: Token de GitHub/GitLab

### 4. Crear Pipeline Job

1. `New Item` → Nombre: `sistema-inventario-pipeline`
2. Tipo: `Pipeline`
3. Pipeline → Definition: `Pipeline script from SCM`
4. SCM: Git
5. Repository URL: `<tu-repo>`
6. Script Path: `Jenkinsfile`

### 5. Ejecutar Pipeline

Click en `Build Now` 🎉

---

## 📋 Checklist Pre-Ejecución

Antes de ejecutar el pipeline, verifica:

- [ ] Jenkins instalado y corriendo
- [ ] Plugins instalados
- [ ] Credenciales AWS configuradas
- [ ] Credencial de DB password configurada
- [ ] Repositorio Git accesible
- [ ] Jenkinsfile en el repositorio
- [ ] Terraform backend S3 creado
- [ ] ECR repository creado

---

## 🔧 Comandos Útiles

### Crear Backend de Terraform
```bash
# S3 bucket
aws s3api create-bucket \
    --bucket sistemainventario-terraform-state \
    --region us-east-2 \
    --create-bucket-configuration LocationConstraint=us-east-2

# DynamoDB table
aws dynamodb create-table \
    --table-name terraform-state-lock \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region us-east-2
```

### Crear ECR Repository
```bash
aws ecr create-repository \
    --repository-name sistemainventario-backend \
    --region us-east-2
```

---

## 🎯 Flujo del Pipeline

```
1. Checkout          → Clonar código
2. TF Unit Tests     → Validar módulos Terraform
3. Build Docker      → Construir imagen del backend
4. App Tests         → Tests de la aplicación
5. SonarQube         → Análisis de calidad
6. Checkov           → Escaneo de seguridad
7. Terraform Plan    → Planificar cambios
8. Approval          → Aprobación manual ⏸️
9. Terraform Apply   → Desplegar infraestructura
10. Validation       → Verificar deployment
```

---

## ⚠️ Problemas Comunes

### Pipeline falla en "Checkout"
```bash
# Verificar credenciales Git
# Verificar URL del repositorio
```

### Pipeline falla en "Build Docker"
```bash
# Verificar credenciales AWS
# Verificar que ECR repository existe
aws ecr describe-repositories --repository-names sistemainventario-backend
```

### Pipeline falla en "Terraform Plan"
```bash
# Verificar backend S3 existe
aws s3 ls s3://sistemainventario-terraform-state

# Verificar credencial db-password
```

---

## 📊 Monitoreo

### Ver logs de Jenkins
```bash
# Docker
docker logs -f jenkins

# EC2
sudo journalctl -u jenkins -f
```

### Ver estado del pipeline
- Blue Ocean UI: `http://localhost:8080/blue`
- Classic UI: `http://localhost:8080/job/sistema-inventario-pipeline/`

---

## 🎓 Próximos Pasos

1. ✅ Configurar notificaciones (Slack/Email)
2. ✅ Configurar SonarQube quality gates
3. ✅ Agregar tests unitarios al backend
4. ✅ Configurar multi-branch pipeline
5. ✅ Implementar pipeline para producción

---

## 📚 Documentación Completa

- [SETUP.md](./SETUP.md) - Guía completa de instalación
- [implementation_plan.md](../../.gemini/antigravity/brain/.../implementation_plan.md) - Plan detallado

---

## 🆘 Soporte

Si encuentras problemas:
1. Revisa los logs del pipeline
2. Consulta la sección de troubleshooting en SETUP.md
3. Verifica que todas las credenciales estén configuradas
