La VPC
La VPC actúa como el cimiento de red para nuestra aplicación web empresarial. Es como un complejo industrial privado donde todos nuestros servicios (frontend, backend, base de datos) estarán alojados de forma segura y aislada del resto de internet, permitiendo control total sobre la conectividad y seguridad.

Tecnologías Implementadas
El código despliega una red con subredes públicas para el frontend accesible desde internet, y subredes privadas para el backend y base de datos. Incluye un Internet Gateway como puerta de entrada principal, un NAT Gateway para permitir conexión saliente segura desde las subredes privadas, y tablas de ruta para dirigir el tráfico correctamente entre todos los componentes.

Justificación de su Uso
Esta arquitectura resuelve directamente los problemas de disponibilidad mediante redundancia en dos zonas, mejora la seguridad aislando la base de datos en subredes privadas, y establece la base para escalabilidad al permitir agregar fácilmente más servidores. El NAT Gateway asegura que los servidores privados puedan actualizarse sin exponerse a internet.

Cumplimiento de Requisitos
La infraestructura creada satisface los requisitos no funcionales: proporciona redundancia geográfica con múltiples zonas de disponibilidad, establece los mecanismos de recuperación ante fallos, y prepara el terreno para la escalabilidad automática que se implementará con balanceadores de carga y auto-scaling groups.
