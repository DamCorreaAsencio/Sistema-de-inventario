variable "vpc_id" {
  description = "ID de la VPC donde se crean los SG"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, prod)"
  type        = string
}