# Módulo: Security Groups

Este módulo define los grupos de seguridad (Security Groups) utilizados en el Sistema de Inventario desplegado sobre AWS.
Cada grupo de seguridad controla el tráfico de red entrante y saliente entre los servicios de la arquitectura (ALB, EC2, etc.), asegurando la comunicación interna y el acceso seguro desde el exterior.

El módulo permite aplicar el principio de mínimo privilegio, definiendo reglas específicas que aseguran que cada servicio solo pueda comunicarse con los componentes necesarios.
Por ejemplo, el ALB acepta tráfico público HTTPS, las EC2 solo reciben peticiones desde el ALB, y la base de datos RDS permite conexiones únicamente desde las instancias del backend dentro de subredes privadas.

Además, se pueden configurar reglas personalizadas para SSH restringido por IP, asegurando el acceso administrativo controlado, y reglas de egreso que permiten la salida hacia servicios externos sin comprometer la seguridad interna.
