# Módulo: VPC

Este módulo implementa la Virtual Private Cloud (VPC) principal del Sistema de Inventario, sirviendo como la base de red donde se despliegan todos los recursos de AWS.
La VPC está configurada con subredes públicas y privadas distribuidas en dos zonas de disponibilidad (us-east-2a y us-east-2b), asegurando alta disponibilidad, aislamiento de recursos y comunicación interna segura.

Además, se incluyen VPC Endpoints para ECR (API y DKR) y S3, permitiendo el acceso privado desde las instancias EC2 a estos servicios sin necesidad de tráfico hacia Internet, optimizando seguridad y costos.
