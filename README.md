# Proyecto Sistema De Inventario

El Sistema de Inventario es una herramienta creada para administrar productos y procesos internos de una empresa. Está desplegado en AWS usando Terraform, lo que asegura disponibilidad constante, capacidad de escalado y protección. Mediante módulos como VPC, EC2, RDS, Load Balancer, API Gateway, S3, CloudFront, Route53 y WAF, se construye una arquitectura automática, robusta y preparada para entornos productivos.
![Imagen de WhatsApp 2025-10-09 a las 15 54 24_89fbf5a8](https://github.com/user-attachments/assets/9b718b47-d957-4bc3-ad7a-f9969f07a994)

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

Nuestro proyecto se puede desplegar mediante estos comandos:

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
Terraform apply --aprove
```
