variable "project" {
  description = "Nombre del proyecto"
  type        = string
}

variable "environment" {
  description = "Entorno (dev, prod)"
  type        = string
  default     = "dev"
}

variable "domain_name" {
  description = "Dominio principal (ejemplo.com)"
  type        = string
  default     = ""
}

variable "subdomain" {
  description = "Subdominio para la aplicación (app, www, etc.)"
  type        = string
  default     = ""
}

variable "api_subdomain" {
  description = "Subdominio para la API (api)"
  type        = string
  default     = "api"
}

variable "cloudfront_domain_name" {
  description = "Dominio de CloudFront"
  type        = string
  default     = ""
}

variable "cloudfront_hosted_zone_id" {
  description = "Hosted Zone ID de CloudFront (Z2FDTNDATAQYW2)"
  type        = string
  default     = "Z2FDTNDATAQYW2" # Este es fijo para CloudFront
}

variable "api_gateway_domain" {
  description = "Dominio del API Gateway"
  type        = string
  default     = ""
}

variable "enable_health_check" {
  description = "Habilitar health check de Route53"
  type        = bool
  default     = false
}

variable "health_check_path" {
  description = "Ruta para el health check"
  type        = string
  default     = "/"
}

variable "sns_topic_arn" {
  description = "ARN del tópico SNS para alarmas"
  type        = string
  default     = ""
}