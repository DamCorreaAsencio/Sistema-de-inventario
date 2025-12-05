variable "project" {
  description = "Nombre del proyecto"
  type        = string
}

variable "environment" {
  description = "Entorno (dev, prod)"
  type        = string
  default     = "dev"
}

variable "blocked_ip_addresses" {
  description = "Lista de IPs a bloquear"
  type        = list(string)
  default     = []
  # Ejemplo: ["192.0.2.1/32", "198.51.100.0/24"]
}

variable "rate_limit" {
  description = "Número máximo de peticiones por IP en 5 minutos"
  type        = number
  default     = 2000
}

variable "enable_linux_protection" {
  description = "Habilitar protección contra vulnerabilidades Linux"
  type        = bool
  default     = true
}

variable "enable_logging" {
  description = "Habilitar logging de WAF"
  type        = bool
  default     = false
}

variable "log_destination_arn" {
  description = "ARN del destino de logs (Kinesis Firehose o S3)"
  type        = string
  default     = ""
}