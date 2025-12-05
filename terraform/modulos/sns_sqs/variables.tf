variable "project" {
  description = "Nombre del proyecto"
  type        = string
}

variable "environment" {
  description = "Entorno (dev, prod)"
  type        = string
  default     = "dev"
}

variable "admin_email" {
  description = "Email del administrador para recibir alertas (opcional)"
  type        = string
  default     = ""
}

variable "sns_monitoring_topic_arn" {
  description = "ARN del tópico SNS para monitoreo (opcional)"
  type        = string
  default     = ""
}

variable "queue_depth_threshold" {
  description = "Umbral de mensajes en cola para generar alarma"
  type        = number
  default     = 100
}