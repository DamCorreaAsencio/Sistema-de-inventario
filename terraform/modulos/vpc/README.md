1. Inicializar Terraform
   
"terraform init"

Este comando descarga e instala todos los proveedores y módulos necesarios para trabajar con AWS, se ejecuta al comenzar el proyecto o cuando se agreguen nuevos componentes a la configuración.

2. Validar la Configuración
   
"terraform validate"

Este comando revisa la sintaxis y estructura del código de Terraform para asegurar que no hay errores, se usa después de modificar cualquier archivo de configuración y muestra un mensaje de éxito si todo es correcto.

3. Ver Plan de Ejecución
   
"terraform plan"

Este comando genera un plan detallado mostrando todos los recursos que se crearán en AWS (VPC, subredes, gateways, tablas de rutas), permite revisar los cambios antes de aplicarlos y no realiza ninguna modificación en la infraestructura real.

4. Aplicar los Cambios
   
"terraform apply"

Este comando ejecuta el plan y crea toda la infraestructura de red en AWS según la configuración definida, solicita confirmación antes de proceder con el despliegue y una vez completado muestra las salidas definidas como los IDs de VPC y subredes.

