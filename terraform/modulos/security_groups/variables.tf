variable "vpc_id" {
  description = "ID de la VPC donde se crearán los SGs"
  type        = string
}

variable "project" {
  description = "Sistema de inventario"
  type        = string
}

variable "environment" {
  description = "Entorno (dev)"
  type        = string
}