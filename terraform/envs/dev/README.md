Este entorno implementa la infraestructura completa del Sistema de Inventario en AWS, gestionada con Terraform bajo el enfoque de Infraestructura como Código (IaC).
Su objetivo es desplegar un entorno modular, automatizado y seguro, asegurando disponibilidad, escalabilidad y trazabilidad para los diferentes servicios que componen la arquitectura.


Para hacer los commits:
git init (por si aún no se inicializó)
git add .
git commit -m "feat o fix"
git push


NOTA PERSONAL XD:
PARA USAR LOS SCRIPTS DE TERRAFORM SIN ERRORES:

terraform init - para iniciar
terraform validate - para ver si todo está ok
terraform plan - muestra lo que se creará en AWS
terraform apply - te crea todo lo que se ha programado

terraform destroy - para que no cobre porque uno no chambea para el pueblo

terraform show - te muestra los recursos desplegadoa
terraform fmt -recursive - Le mete APA al código 