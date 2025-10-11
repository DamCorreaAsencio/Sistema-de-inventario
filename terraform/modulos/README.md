# Terraform Módulos – Sistema de Inventario

Este directorio contiene los módulos reutilizables de Terraform utilizados para desplegar la infraestructura del Sistema de Inventario en AWS.
Cada módulo representa un servicio o componente independiente, lo que facilita el mantenimiento, la escalabilidad y la automatización del entorno.

Modulos con sus descripciones:

1. vpc/
  
Configura la red principal (VPC), subredes públicas y privadas, gateway y tablas de ruteo.

2. security_groups/

Define las reglas de seguridad (ingreso/salida) para las instancias y servicios.

3. ec2/	

Despliega las instancias EC2 del backend con Auto Scaling.

4. loadbalancer/	

Implementa el Application Load Balancer (ALB) para distribuir tráfico entre las EC2.

5. apigateway/	

Gestiona las APIs y redirige solicitudes hacia el ALB.

6. rdsmulti/	

Crea la base de datos MySQL en Amazon RDS con replicación Multi-AZ.

7. s3/	

Crea el bucket para almacenamiento de objetos o respaldos.

8. ecr/	

Configura el repositorio de contenedores para almacenar imágenes Docker.

9. cloudfront/	

Implementa la red de distribución de contenido (CDN) para optimizar el acceso global.

10. waf/	

Configura el Web Application Firewall para proteger el sistema contra ataques web.

11. route53/	

Gestiona los registros DNS del dominio y enruta tráfico a CloudFront o ALB.

12. cloudwatch/	

Implementa la monitorización de recursos y métricas del sistema.
