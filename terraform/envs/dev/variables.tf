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
  # NO pongas la contraseña aquí, usa terraform.tfvars o variables de entorno
}