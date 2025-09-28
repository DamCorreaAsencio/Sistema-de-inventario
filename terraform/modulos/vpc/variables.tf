variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev, prod)"
  type        = string
}


/*variable "project" {
  type        = string
  description = "Nombre del proyecto"
}

variable "env" {
  type        = string
  description = "Entorno (dev/prod)"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR de la VPC"
}

variable "public_subnets" {
  type        = list(string)
  description = "Lista de CIDRs para subnets públicas"
}

variable "private_subnets" {
  type        = list(string)
  description = "Lista de CIDRs para subnets privadas"
}

variable "azs" {
  type        = list(string)
  description = "Lista de zonas de disponibilidad"
}*/