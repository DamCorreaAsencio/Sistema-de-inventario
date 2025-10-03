# Nombre del proyecto (usado en el nombre del repo)
variable "project" {
  description = "Sistema de Inventario"
  type        = string
}

# Entorno (dev, prod, etc.)
variable "environment" {
  description = "Entorno dev"
  type        = string
}