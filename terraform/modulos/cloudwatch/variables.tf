variable "project" {
  description = "Nombre del proyecto"
  type        = string
}

variable "environment" {
  description = "Entorno (dev, prod)"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "Región de AWS"
  type        = string
}

variable "log_retention_days" {
  description = "Días de retención de logs"
  type        = number
  default     = 7
}

variable "ecs_cluster_name" {
  description = "Nombre del cluster ECS"
  type        = string
}

variable "ecs_service_name" {
  description = "Nombre del servicio ECS"
  type        = string
}

variable "rds_instance_id" {
  description = "ID de la instancia RDS"
  type        = string
}

variable "alb_arn_suffix" {
  description = "ARN suffix del ALB para métricas"
  type        = string
}

variable "sns_topic_arn" {
  description = "ARN del tópico SNS para alarmas"
  type        = string
  default     = ""
}

variable "ecs_cpu_threshold" {
  description = "Umbral de CPU para alarma ECS (%)"
  type        = number
  default     = 80
}

variable "ecs_memory_threshold" {
  description = "Umbral de memoria para alarma ECS (%)"
  type        = number
  default     = 80
}

variable "rds_cpu_threshold" {
  description = "Umbral de CPU para alarma RDS (%)"
  type        = number
  default     = 80
}

variable "rds_storage_threshold" {
  description = "Umbral de almacenamiento libre en RDS (bytes)"
  type        = number
  default     = 5368709120 # 5GB
}

variable "alb_5xx_threshold" {
  description = "Número de errores 5xx para generar alarma"
  type        = number
  default     = 10
}