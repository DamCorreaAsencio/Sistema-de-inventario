variable "project" {
  description = "Nombre del proyecto"
  type        = string
}

variable "region" {
  description = "Región de AWS"
  type        = string
}

variable "account_id" {
  description = "ID de la cuenta AWS"
  type        = string
}

variable "repo_name" {
  description = "Nombre del repositorio ECR"
  type        = string
}

variable "cpu" {
  description = "CPU para la tarea Fargate"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Memoria para la tarea Fargate"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Número de tareas deseadas"
  type        = number
  default     = 1
}

variable "private_subnet_ids" {
  description = "IDs de las subnets privadas"
  type        = list(string)
}

variable "ecs_sg_id" {
  description = "ID del Security Group de ECS"
  type        = string
}

variable "target_group_arn" {
  description = "ARN del Target Group del ALB"
  type        = string
}

variable "lb_listener" {
  description = "ARN del Listener del Load Balancer"
  type        = string
}
variable "sns_topic_arn" {
  description = "ARN del tópico SNS para alertas"
  type        = string
  default     = ""
}
variable "image_tag" {
  type = string
}
