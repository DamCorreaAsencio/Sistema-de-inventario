1. Inicializar Terraform
terraform init

Este comando descarga e instala todo lo necesario para trabajar con AWS, se usa al comenzar o cuando agregues nuevos módulos siempre y cuando sea una vez al inicio o después de cambios en la configuración.

2. Validar la Configuración
"terraform validate"

Este comando revisa que nuestro código esté bien escrito sin errores de sintaxis, se usa después de hacer cambios en el código y te saldra Success! si todo está correcto.

3. Ver Plan de Ejecución
"terraform plan"

Este comando muestra qué recursos se van a crear/modificar/eliminar, se usa antes de aplicar cambios para revisar lo que pasará y es importante saber que no hace cambios, solo muestra el plan.

4. Aplicar los Cambios
"terraform apply"

Este comando crea los recursos en AWS en base a nuestro código, se usa cuando estamos seguros del plan mostrado y nos pedirá confirmación antes de ejecutar.


