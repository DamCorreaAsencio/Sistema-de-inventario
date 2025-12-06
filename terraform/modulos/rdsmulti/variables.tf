variable "project" {
  description = "Nombre del proyecto"
  type        = string
}

variable "environment" {
  description = "Entorno (dev, prod)"
  type        = string
  default     = "dev"
}

########################################
variable "region" {
  description = "Región de AWS"
  type        = string
}
#########################################

variable "rds_subnet_ids" {
  description = "IDs de las subnets para RDS (mínimo 2 en diferentes AZs)"
  type        = list(string)
}

variable "rds_sg_id" {
  description = "ID del Security Group para RDS"
  type        = string
}

variable "engine_version" {
  description = "Versión de MySQL"
  type        = string
  default     = "8.0.39"
}

variable "instance_class" {
  description = "Clase de instancia RDS"
  type        = string
  default     = "db.t3.micro" 
}

variable "allocated_storage" {
  description = "Almacenamiento inicial en GB"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Almacenamiento máximo para autoscaling en GB"
  type        = number
  default     = 100
}

variable "db_name" {
  description = "Nombre de la base de datos"
  type        = string
  default     = "inventario"
}

variable "db_username" {
  description = "Usuario master de la BD"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Contraseña del usuario master"
  type        = string
  sensitive   = true
}

variable "backup_retention_period" {
  description = "Días de retención de backups"
  type        = number
  default     = 1
}

variable "skip_final_snapshot" {
  description = "Si es true, no crea snapshot final al destruir"
  type        = bool
  default     = true # Cambiar a false en producción
}

variable "deletion_protection" {
  description = "Protección contra eliminación accidental"
  type        = bool
  default     = false # Cambiar a true en producción
}

variable "max_connections" {
  description = "Número máximo de conexiones concurrentes"
  type        = string
  default     = "100"
}