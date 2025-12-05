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
  description = "Dominio personalizado (opcional)"
  type        = string
  default     = ""
}

variable "api_gateway_domain" {
  description = "Dominio del API Gateway"
  type        = string
}

variable "price_class" {
  description = "Clase de precio de CloudFront"
  type        = string
  default     = "PriceClass_100" # Más barato: USA, Canadá, Europa
  # PriceClass_200: + Asia, África, Oceanía
  # PriceClass_All: Todas las ubicaciones
}

variable "waf_acl_id" {
  description = "ID del ACL de WAF (opcional)"
  type        = string
  default     = ""
}