variable "project" {
  description = "Nombre del proyecto"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_id" {
  description = "ID de la VPC donde se crea el ALB"
  type        = string
}

variable "public_subnets" {
  description = "Lista de subredes públicas para el ALB"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "ID del Security Group para el ALB"
  type        = string
}