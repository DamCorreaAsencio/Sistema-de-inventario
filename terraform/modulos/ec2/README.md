# Modulo ec2

Este módulo despliega y configura las instancias EC2 que ejecutan la lógica del Sistema de Inventario.
Las instancias se encuentran en subredes privadas, reciben tráfico a través del Application Load Balancer (ALB) y están asociadas a un Auto Scaling Group para garantizar alta disponibilidad y escalabilidad automática.
