# Jenkins CI/CD Pipeline - README

## 📁 Estructura del Proyecto

```
Sistema-de-inventario/
├── Jenkinsfile                          # Pipeline principal
├── jenkins/
│   ├── QUICKSTART.md                    # Guía de inicio rápido
│   ├── SETUP.md                         # Guía completa de instalación
│   ├── scripts/
│   │   ├── terraform-test.sh            # Tests unitarios de Terraform
│   │   ├── build-docker.sh              # Build y push de imágenes Docker
│   │   ├── run-tests.sh                 # Tests de aplicación
│   │   └── deploy-validation.sh         # Validación post-deployment
│   └── config/
│       ├── sonar-project.properties     # Configuración SonarQube
│       └── checkov.yaml                 # Configuración Checkov
├── terraform/                           # Infraestructura como código
├── backend/                             # Backend Node.js
└── frontend/                            # Frontend React
```

## 🚀 Inicio Rápido

### Prerrequisitos
- Jenkins instalado (ver [QUICKSTART.md](./jenkins/QUICKSTART.md))
- AWS CLI configurado
- Credenciales configuradas en Jenkins

### Pasos
1. Crear backend de Terraform (S3 + DynamoDB)
2. Crear repositorio ECR
3. Configurar credenciales en Jenkins
4. Crear pipeline job en Jenkins
5. Ejecutar pipeline

Ver guía completa: [jenkins/QUICKSTART.md](./jenkins/QUICKSTART.md)

## 📊 Pipeline Stages

| Stage | Descripción | Duración Aprox. |
|-------|-------------|-----------------|
| Checkout | Clonar repositorio | 10s |
| Terraform Unit Tests | Validar módulos TF | 2-3 min |
| Build Docker | Construir imagen backend | 3-5 min |
| Application Tests | Tests unitarios | 1-2 min |
| SonarQube | Análisis de calidad | 2-3 min |
| Checkov | Escaneo de seguridad | 1-2 min |
| Terraform Plan | Planificar cambios | 2-3 min |
| Approval | Aprobación manual | Variable |
| Terraform Apply | Desplegar infraestructura | 10-15 min |
| Validation | Verificar deployment | 2-3 min |

**Total**: ~25-40 minutos (sin approval)

## 🔧 Configuración

### Variables de Entorno

El pipeline usa estas variables (configuradas automáticamente):
- `AWS_REGION`: us-east-2
- `AWS_ACCOUNT_ID`: 251740340893
- `ECR_REPO`: sistemainventario-backend
- `PROJECT_NAME`: sistema-inventario
- `ENVIRONMENT`: dev

### Credenciales Requeridas

En Jenkins (`Manage Jenkins > Credentials`):
- `aws-credentials`: AWS Access Key + Secret
- `db-password`: Contraseña de RDS
- `sonarqube-token`: Token de SonarQube
- `git-credentials`: Token de Git

## 📝 Documentación

- **[QUICKSTART.md](./jenkins/QUICKSTART.md)**: Inicio rápido (5 minutos)
- **[SETUP.md](./jenkins/SETUP.md)**: Guía completa de instalación
- **[implementation_plan.md](../.gemini/antigravity/brain/.../implementation_plan.md)**: Plan detallado de implementación

## 🛠️ Scripts

### terraform-test.sh
Valida todos los módulos de Terraform:
- Formato (terraform fmt)
- Inicialización
- Validación sintáctica

### build-docker.sh
Construye y publica imagen Docker:
- Build con multi-tags
- Login a ECR
- Push a repositorio

### run-tests.sh
Ejecuta tests de aplicación:
- Instalación de dependencias
- Linting
- Tests unitarios
- Security audit

### deploy-validation.sh
Valida deployment:
- Health check de ALB
- Verificación de API Gateway
- Estado de ECS service
- Conectividad RDS

## 🔒 Seguridad

- ✅ Credenciales en Jenkins Credentials Store
- ✅ Escaneo de seguridad con Checkov
- ✅ Análisis de código con SonarQube
- ✅ Secrets no en código
- ✅ Imágenes Docker escaneadas

## 📈 Monitoreo

### Logs
```bash
# Jenkins logs (Docker)
docker logs -f jenkins

# Jenkins logs (EC2)
sudo journalctl -u jenkins -f
```

### Dashboards
- Jenkins: `http://jenkins-url:8080`
- Blue Ocean: `http://jenkins-url:8080/blue`
- SonarQube: `http://sonarqube-url:9000`

## 🐛 Troubleshooting

### Pipeline falla en Terraform
```bash
# Verificar backend
aws s3 ls s3://sistemainventario-terraform-state

# Verificar lock table
aws dynamodb describe-table --table-name terraform-state-lock
```

### Pipeline falla en Docker
```bash
# Verificar ECR
aws ecr describe-repositories --repository-names sistemainventario-backend

# Verificar credenciales AWS
aws sts get-caller-identity
```

### Pipeline falla en Tests
```bash
# Ejecutar localmente
cd backend
npm ci
npm test
```

Ver más en: [jenkins/SETUP.md#troubleshooting](./jenkins/SETUP.md#troubleshooting)

## 🎯 Mejores Prácticas Implementadas

1. **Pipeline como Código**: Jenkinsfile versionado
2. **Fail Fast**: Detener en primer error
3. **Parallel Stages**: Cuando es posible
4. **Artifacts**: Guardar planes y reportes
5. **Approval Gates**: Para cambios críticos
6. **Notifications**: Alertas de éxito/fallo
7. **Cleanup**: Limpieza automática de workspace
8. **Timeouts**: Prevenir pipelines colgados

## 📞 Soporte

Para problemas o preguntas:
1. Revisar logs del pipeline
2. Consultar documentación en `jenkins/`
3. Verificar configuración de credenciales
4. Revisar estado de servicios AWS

## 🔄 Actualizaciones

Para actualizar el pipeline:
1. Modificar `Jenkinsfile`
2. Commit y push
3. Pipeline se actualizará automáticamente

## 📜 Licencia

Este proyecto es parte del Sistema de Inventario.
