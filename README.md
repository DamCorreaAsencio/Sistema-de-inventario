# Sistema de inventario

![59816c1b-6a29-4883-b178-1981fe2cdc3c](https://github.com/user-attachments/assets/3bba4138-8211-4db8-bfd9-c58f50b4a73a)

1) Resumen ejecutivo de la arquitectura
   
Arquitectura web en AWS orientada a alta disponibilidad y escalado: los usuarios llegan por Internet → DNS (Route 53) → CDN/Edge (CloudFront + WAF) → API (API Gateway) → balanceador (ALB en subnet pública) → backend en EC2 (contenedores Docker) desplegados en Auto Scaling across AZs (subnets privadas). El frontend está en S3 servido por CloudFront. La base de datos es RDS Multi-AZ en subnets privadas. El pipeline de desarrollo usa GitHub → Terraform (infra) + Ansible (config) → ECR (imagenes Docker) → EC2 las ejecuta.

El proyecto se puede desplegar 
Terraform init
Terraform plan
Terraform apply --aprove
