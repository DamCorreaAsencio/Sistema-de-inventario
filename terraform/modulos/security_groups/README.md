# Seguridad por Capas
 
Los Security Groups actúan como guardias de seguridad digitales que controlan el tráfico entre los componentes de nuestra aplicación. Implementan el principio de "mínimo privilegio", donde cada servicio solo puede comunicarse con lo estrictamente necesario para funcionar.

**Tecnologías Implementadas**

Se configuran tres grupos de seguridad especializados: ALB para tráfico web público, EC2 para servidores de aplicación backend, y RDS para la base de datos. Cada grupo define reglas específicas de entrada y salida, creando una arquitectura de seguridad en capas donde el tráfico fluye de forma controlada y segura.

**Justificación de su Uso**

Esta estrategia de seguridad segmentada protege la aplicación aislando la base de datos del acceso directo desde internet, permitiendo solo comunicación desde los servidores EC2. El Load Balancer actúa como único punto de entrada público, mientras los servidores backend permanecen protegidos y la base de datos completamente aislada en la red privada.

**Cumplimiento de Requisitos**

Los grupos de seguridad garantizan la disponibilidad al permitir solo tráfico legítimo, implementan seguridad robusta mediante segmentación de red, y establecen los controles necesarios para la escalabilidad automática futura, donde nuevas instancias heredarán automáticamente estas reglas de seguridad.
