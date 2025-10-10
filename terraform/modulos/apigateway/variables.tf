variable "project" {
  description = "Sistema de Inventario"
  type        = string
}

variable "region" {
  description = "Región AWS"
  type        = string
}

variable "alb_dns_name" {
  description = "DNS público del Load Balancer (ALB)"
  type        = string
}

variable "stage_name" {
  description = "Stage del API Gatewa (dev)"
  default     = "dev"
}