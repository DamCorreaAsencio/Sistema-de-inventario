variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "aws_profile" {
  description = "AWS profile"
  type        = string
  default     = "raulichoRod" //cambiar con su usuario (IAM)
}

# Nuevas variables para RDS
variable "db_username" {
  description = "Usuario master de la base de datos"
  type        = string
  sensitive   = true
  default     = "admin"
}

variable "db_password" {
  description = "Contraseña del usuario master"
  type        = string
  sensitive   = true
  # NO poner tu contraseña aquí. Usar terraform.tfvars o variables de entorno... o tu bloc de notas aña
}