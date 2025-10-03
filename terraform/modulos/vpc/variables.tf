# Nombre del proyecto (para tags)
variable "project" {
  description = "Nombre del proyecto para etiquetar recursos"
  type        = string
}

# CIDR principal de la VPC
variable "vpc_cidr" {
  description = "CIDR de la VPC"
  type        = string
}

# Zonas de disponibilidad
variable "azs" {
  description = "Lista de zonas de disponibilidad en la región"
  type        = list(string)
}

# Subnets públicas
variable "public_subnets" {
  description = "Lista de CIDR blocks para subnets públicas"
  type        = list(string)
}

# Subnets privadas
variable "private_subnets" {
  description = "Lista de CIDR blocks para subnets privadas"
  type        = list(string)
}
