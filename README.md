# Sistema de Inventario - Jenkins CI/CD Pipeline

## 📖 Descripción

Pipeline completo de CI/CD con Jenkins para automatizar el despliegue de infraestructura AWS usando Terraform, incluyendo:

- ✅ Unit tests de módulos Terraform
- ✅ Construcción de imágenes Docker
- ✅ Tests de aplicación
- ✅ Análisis de calidad con SonarCloud
- ✅ Escaneo de seguridad con Checkov
- ✅ Despliegue automatizado a AWS

## 🚀 Inicio Rápido

### Para Colaboradores

Si eres un colaborador nuevo, sigue la guía completa:

📘 **[GUIA-COLABORADOR.md](./GUIA-COLABORADOR.md)** - Configuración paso a paso desde cero

### Para Desarrollo Local

Si ya tienes Jenkins configurado:

📗 **[INICIO-RAPIDO.md](./INICIO-RAPIDO.md)** - Guía rápida de 10 minutos

## 📁 Estructura del Proyecto

```
Sistema-de-inventario/
├── Jenkinsfile                          # Pipeline principal
├── GUIA-COLABORADOR.md                  # 👈 EMPIEZA AQUÍ si eres nuevo
├── INICIO-RAPIDO.md                     # Guía rápida
├── docker-compose.jenkins.yml           # Configuración Jenkins
├── install-jenkins.bat/.sh              # Scripts de instalación
├── create-aws-resources.bat/.sh         # Scripts para AWS
├── jenkins/
│   ├── LOCAL-SETUP.md                   # Guía detallada local
│   ├── SETUP.md                         # Guía completa
│   ├── QUICKSTART.md                    # Inicio rápido
│   ├── README.md                        # Documentación general
│   ├── scripts/                         # Scripts del pipeline
│   │   ├── terraform-test.sh
│   │   ├── build-docker.sh
│   │   ├── run-tests.sh
│   │   └── deploy-validation.sh
│   └── config/                          # Configuraciones
│       ├── sonar-project.properties
│       └── checkov.yaml
├── terraform/                           # Infraestructura como código
├── backend/                             # Backend Node.js
└── frontend/                            # Frontend React
```

## 🎯 Características del Pipeline

### Stages Implementados

| Stage | Descripción | Duración |
|-------|-------------|----------|
| Checkout | Clona el repositorio | 10s |
| Terraform Unit Tests | Valida módulos Terraform | 2 min |
| Build Docker | Construye imagen backend | 3 min |
| Application Tests | Tests unitarios | 1 min |
| SonarCloud Analysis | Análisis de calidad | 2 min |
| Checkov Security Scan | Escaneo de seguridad | 1 min |
| Terraform Plan | Planifica cambios | 2 min |
| Approval | Aprobación manual | Variable |
| Terraform Apply | Despliega infraestructura | 15 min |
| Deploy Validation | Verifica deployment | 2 min |

**Total:** ~25-30 minutos (con deployment completo)

### Seguridad

- ✅ Credenciales en Jenkins Credentials Store
- ✅ Escaneo de seguridad con Checkov
- ✅ Análisis de vulnerabilidades con SonarCloud
- ✅ Secrets no en código
- ✅ Imágenes Docker escaneadas

### Calidad

- ✅ Unit tests antes de deploy
- ✅ Quality gates en SonarCloud
- ✅ Terraform validate y plan obligatorios
- ✅ Revisión manual antes de apply

## 💰 Costos AWS

### Testing (Actual)
- S3 bucket: $0.01/mes
- DynamoDB: $0 (free tier)
- ECR: $0.10/mes
- **Total: ~$0.15/mes** ✅

### Producción (Infraestructura completa)
- RDS Multi-AZ: ~$30/mes
- ECS Fargate: ~$20/mes
- ALB: ~$20/mes
- CloudFront: ~$10/mes
- Otros: ~$20/mes
- **Total: ~$150-200/mes** ⚠️

## 📋 Prerrequisitos

- Docker Desktop
- Git
- AWS CLI
- Credenciales AWS (Access Key + Secret Key)
- Cuenta en SonarCloud (gratis)

## 🔧 Configuración

### 1. Clonar Repositorio

```bash
git clone https://github.com/DamCorreaAsencio/Sistema-de-inventario.git
cd Sistema-de-inventario
git checkout pruebaJenkins
```

### 2. Instalar Jenkins

**Windows:**
```cmd
.\install-jenkins.bat
```

**Linux/Mac:**
```bash
bash install-jenkins.sh
```

### 3. Crear Recursos AWS

```cmd
.\create-aws-resources.bat
```

### 4. Configurar Jenkins

Seguir la guía: [GUIA-COLABORADOR.md](./GUIA-COLABORADOR.md)

## 🎓 Documentación

- 📘 **[GUIA-COLABORADOR.md](./GUIA-COLABORADOR.md)** - Para nuevos colaboradores
- 📗 **[INICIO-RAPIDO.md](./INICIO-RAPIDO.md)** - Guía rápida
- 📕 **[jenkins/LOCAL-SETUP.md](./jenkins/LOCAL-SETUP.md)** - Setup local detallado
- 📙 **[jenkins/SETUP.md](./jenkins/SETUP.md)** - Guía completa
- 🔌 **[jenkins/PLUGINS.md](./jenkins/PLUGINS.md)** - Lista de plugins necesarios

## 🐛 Troubleshooting

### Jenkins no inicia
```bash
docker logs jenkins
docker-compose -f docker-compose.jenkins.yml restart
```

### Pipeline falla
- Revisar logs en Jenkins Console Output
- Verificar credenciales AWS
- Verificar configuración de SonarCloud

Ver más en: [GUIA-COLABORADOR.md#troubleshooting](./GUIA-COLABORADOR.md#troubleshooting)

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama: `git checkout -b feature/nueva-funcionalidad`
3. Commit: `git commit -m 'feat: nueva funcionalidad'`
4. Push: `git push origin feature/nueva-funcionalidad`
5. Abre un Pull Request

## 📞 Soporte

Para problemas o preguntas:
1. Revisar documentación en carpeta `jenkins/`
2. Revisar logs del pipeline
3. Verificar configuración de credenciales

## 📜 Licencia

Este proyecto es parte del Sistema de Inventario.

---

**Desarrollado con ❤️ para automatizar el despliegue de infraestructura AWS**
