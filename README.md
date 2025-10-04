# Sistema de inventario

El Sistema de Inventario es una solución diseñada para gestionar productos y operaciones internas de una empresa. La infraestructura está implementada en AWS mediante Terraform, garantizando alta disponibilidad, escalabilidad y seguridad. A través de los diferentes módulos (VPC, EC2, RDS, Load Balancer, API Gateway, S3, CloudFront, Route53 y WAF), se busca cubrir una arquitectura resiliente y automatizada, optimizada para entornos de producción.

![59816c1b-6a29-4883-b178-1981fe2cdc3c](https://github.com/user-attachments/assets/3bba4138-8211-4db8-bfd9-c58f50b4a73a)

# Atributos de calidad
1. Disponibilidad

En la arquitectura actual, la disponibilidad es baja porque el sistema depende de un único servidor de base de datos y de instancias individuales de microservicios. La ausencia de redundancia y mecanismos de   recuperación automática significa que, si alguno de estos componentes falla, la plataforma completa puede quedar inoperativa durante horas. Esto hace que incluso fallos menores provoquen interrupciones prolongadas en el servicio.

2. Escalabilidad

La escalabilidad también es limitada, ya que el sistema no cuenta con balanceadores de carga ni con la capacidad de escalar horizontalmente. Si aumenta la cantidad de usuarios o transacciones, la infraestructura no está preparada para distribuir la carga ni añadir recursos dinámicamente. Esto genera riesgo de lentitud o caída total del sistema en escenarios de alta demanda.


# Resumen ejecutivo de la arquitectura
   
Arquitectura web en AWS orientada a alta disponibilidad y escalado: los usuarios llegan por Internet → DNS (Route 53) → CDN/Edge (CloudFront + WAF) → API (API Gateway) → balanceador (ALB en subnet pública) → backend en EC2 (contenedores Docker) desplegados en Auto Scaling across AZs (subnets privadas). El frontend está en S3 servido por CloudFront. La base de datos es RDS Multi-AZ en subnets privadas. El pipeline de desarrollo usa GitHub → Terraform (infra) + Ansible (config) → ECR (imagenes Docker) → EC2 las ejecuta.

El proyecto se puede desplegar 

```bash
Terraform init
```
```bash
Terraform plan
```
```bash
Terraform apply --aprove
```


