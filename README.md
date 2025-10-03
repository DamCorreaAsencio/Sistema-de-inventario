# Proyecto "Sistema de inventario"
El Sistema de Inventario es una solución diseñada para gestionar productos y operaciones internas de una empresa. La infraestructura está implementada en AWS mediante Terraform, garantizando alta disponibilidad, escalabilidad y seguridad. A través de los diferentes módulos (VPC, EC2, RDS, Load Balancer, API Gateway, S3, CloudFront, Route53 y WAF), se busca cubrir una arquitectura resiliente y automatizada, optimizada para entornos de producción.

![Diagrama API Gateway](https://github.com/user-attachments/assets/e619574a-51e3-4237-8db2-faf49a1a8057)
Diagrama propuesto
# Integrantes:

1. Ahumada Soles Carlos
2. Calluchi Patiño  Eduardo
3. Principe Huamanchumo Luis
4. Sandoval Vargas Robert
5. Correa Asencio Damer

*Contexto*

En la actualidad, las empresas buscan soluciones tecnológicas que permitan optimizar la interacción con sus clientes y mejorar la gestión de sus procesos internos. Una aplicación web con frontend y backend integrados brinda la capacidad de ofrecer servicios digitales disponibles en todo momento, con seguridad y escalabilidad.
El uso de servicios en la nube, como AWS EC2 y RDS, proporciona a las organizaciones una infraestructura confiable, reduciendo la dependencia de servidores locales y garantizando disponibilidad para los usuarios finales.

*Problemática*

La empresa enfrenta dificultades relacionadas con:
Disponibilidad: los sistemas locales sufren caídas o interrupciones en horarios críticos.
Escalabilidad: el aumento de usuarios genera lentitud y pérdida de clientes potenciales.
Gestión de infraestructura: los servidores tradicionales requieren altos costos de mantenimiento y personal especializado.
Recuperación ante fallos: la falta de redundancia expone a la empresa a riesgos de pérdida de información y de clientes.
Por ello, se requiere implementar una arquitectura en la nube que garantice alta disponibilidad, seguridad y eficiencia en costos.

*Objetivos*

Diseñar e implementar una aplicación web con backend y frontend desplegados en AWS, asegurando disponibilidad y escalabilidad mediante el uso de instancias EC2, balanceadores de carga, y base de datos gestionada.

REQUISITOS NO FUNCIONALES:
Escalabilidad automática: La infraestructura debe ser capaz de ajustar automáticamente el número de instancias en función del tráfico, garantizando la disponibilidad ante picos de demanda sin intervención manual.

Redundancia geográfica: Debe haber instancias desplegadas en múltiples zonas de disponibilidad (AZ) dentro de la misma región, para asegurar que si una AZ falla, las otras sigan operativas.

Recuperación ante fallos: La infraestructura debe contar con mecanismos automáticos de failover y backups periódicos, permitiendo la rápida recuperación de servicios en caso de fallos.

