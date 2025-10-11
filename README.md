# Proyecto Sistema De Inventario

La gestión del inventario en la empresa se realizaba sobre una infraestructura poco flexible, con configuraciones manuales y sin mecanismos adecuados de respaldo o recuperación ante fallos.
Esto ocasionaba interrupciones en el servicio, errores en el control de productos y dificultades para escalar la plataforma ante un aumento de usuarios o transacciones. El Sistema de Inventario que implementamos es una herramienta creada para administrar productos y procesos internos de una empresa. Está desplegado en AWS usando Terraform, lo que asegura disponibilidad constante, capacidad de escalado y protección. Mediante módulos como VPC, EC2, RDS, Load Balancer, API Gateway, S3, CloudFront, Route53 y WAF, se construye una arquitectura automática, robusta y preparada para entornos productivos.

![Imagen de WhatsApp 2025-10-09 a las 15 54 24_89fbf5a8](https://github.com/user-attachments/assets/9b718b47-d957-4bc3-ad7a-f9969f07a994)

Diagrama de arquitectura propuesto

El sistema de inventario ha sido diseñado considerando atributos de calidad (ilities) que garantizan su rendimiento, disponibilidad y seguridad en entornos de producción. Cada ility deriva de un requerimiento no funcional específico, y su cumplimiento se evalúa mediante métricas medibles dentro de AWS, como disponibilidad (99%), tiempo de despliegue (>10 min), y detección de fallos (<1 min).
La arquitectura (basada en AWS) incorpora componentes que refuerzan estos atributos: alta disponibilidad (RDS Multi-AZ, ALB), escalabilidad (Auto Scaling), seguridad (WAF, IAM, subredes privadas), mantenibilidad (Terraform y CI/CD), y confiabilidad (CloudWatch + SNS).


El Sistema de Inventario desarrollado sobre la infraestructura de AWS tiene como propósito solucionar estos problemas dentro de una empresa:
1. Vulnerabilidad en la seguridad de datos

Los datos de inventario y usuarios estaban expuestos a accesos no autorizados.

2. Retrasos en la actualización de la información

La información no se sincronizaba oportunamente entre las diferentes áreas.

3. Escalabilidad limitada ante el crecimiento de la demanda

El sistema anterior no soportaba el incremento de usuarios o transacciones simultáneas.

4. Baja disponibilidad y resiliencia del sistema

Las caídas de servidores comprometían la continuidad del servicio.

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








