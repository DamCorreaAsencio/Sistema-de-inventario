# Modulo Application Load Balancer (ALB)

Este módulo crea un Application Load Balancer (ALB) público en AWS, que distribuye el tráfico HTTP entrante hacia las instancias EC2 del backend del Sistema de Inventario.
El ALB permite mantener alta disponibilidad, escalabilidad y tolerancia a fallos, garantizando que las peticiones de los usuarios sean atendidas de forma eficiente por las instancias activas.

El módulo también incluye la configuración de un Target Group con comprobaciones de salud (health_check) y un Listener HTTP (puerto 80) que enruta las solicitudes entrantes al backend de manera automática.

