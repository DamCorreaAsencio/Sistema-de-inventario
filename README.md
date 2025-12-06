# Proyecto Sistema De Inventario

Integrantes:

1. Ahumada Soles Carlos

2. Calluchi Patiño Eduardo

3. Principe Huamanchumo Luis

4. Sandoval Vargas Robert

5. Correa Asencio Damer



La gestión del inventario en la empresa se realizaba sobre una infraestructura poco flexible, con configuraciones manuales y sin mecanismos adecuados de respaldo o recuperación ante fallos.
Esto ocasionaba interrupciones en el servicio, errores en el control de productos y dificultades para escalar la plataforma ante un aumento de usuarios o transacciones. El Sistema de Inventario que implementamos es una herramienta creada para administrar productos y procesos internos de una empresa. Está desplegado en AWS usando Terraform, lo que asegura disponibilidad constante, capacidad de escalado y protección. Mediante módulos como VPC, RDS, Load Balancer, API Gateway, S3, CloudFront, Route53 y WAF, se construye una arquitectura automática, robusta y preparada para entornos productivos.

![Imagen de WhatsApp 2025-10-09 a las 15 54 24_89fbf5a8](https://github.com/user-attachments/assets/a7bdb18d-ad87-4763-a94b-02c5bf8435da)

Diagrama de arquitectura propuesto

El Sistema de Inventario desarrollado sobre la infraestructura de AWS tiene como propósito solucionar estos problemas dentro de una empresa:
1. Vulnerabilidad en la seguridad de datos

Los datos de inventario y usuarios estaban expuestos a accesos no autorizados.

2. Retrasos en la actualización de la información

La información no se sincronizaba oportunamente entre las diferentes áreas.

3. Escalabilidad limitada ante el crecimiento de la demanda

El sistema anterior no soportaba el incremento de usuarios o transacciones simultáneas.

4. Baja disponibilidad y resiliencia del sistema

Las caídas de servidores comprometían la continuidad del servicio.

El sistema de inventario ha sido diseñado siguiendo cinco requerimientos no funcionales que garantizan su estabilidad y eficiencia en un entorno productivo. 

En primer lugar, se prioriza la disponibilidad, asegurando que la plataforma se mantenga operativa incluso ante fallos de componentes mediante el uso de RDS Multi-AZ, balanceadores de carga (ALB) y la distribución de instancias EC2 en dos zonas de disponibilidad, alcanzando un nivel de servicio del 95%.

La escalabilidad también es un aspecto clave, permitiendo que la infraestructura se adapte automáticamente ante incrementos de carga o usuarios, gracias a la implementación de Auto Scaling en las instancias EC2, balanceo dinámico con ALB y el enrutamiento gestionado a través de API Gateway, manteniendo tiempos de ajuste inferiores a dos minutos.

En cuanto a la seguridad, se garantiza la protección de los datos y recursos del sistema mediante el uso de subredes privadas, políticas de identidad y acceso (IAM), comunicación cifrada bajo HTTPS, y un firewall de aplicaciones web (WAF) que bloquea accesos no autorizados, con un máximo de tres intentos fallidos por mes.

La mantenibilidad se aborda mediante la automatización total del despliegue y actualización de la infraestructura, utilizando Terraform, Ansible y pipelines CI/CD con GitHub Actions y ECR, permitiendo tiempos de despliegue inferiores a 10 minutos y asegurando la reproducibilidad del entorno.

Finalmente, se refuerza la confiabilidad del sistema mediante un monitoreo constante y notificaciones automáticas de fallos, logradas con la integración de CloudWatch y SNS, que permiten detectar y alertar sobre incidentes en menos de un minuto, garantizando una rápida respuesta ante cualquier eventualidad.

Nuestro proyecto se puede desplegar mediante estos comandos:

```bash
cd .\terraform\dev\evs\
```

```bash
Terraform init
```

```bash
Terraform validate
```

```bash
Terraform plan
```

```bash
Terraform apply -auto-approve
```

```bash
Terraform destroy
```



















