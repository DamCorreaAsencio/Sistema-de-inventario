variable "ami_id" {
  description = "AMI a usar para EC2"
  type        = string
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
}

variable "subnet_id" {
  description = "Subred pública donde lanzar la EC2"
  type        = string
}

variable "security_group_id" {
  description = "Security Group de la EC2"
  type        = string
}

variable "key_name" {
  description = "Nombre del par de llaves para SSH"
  type        = string
}

variable "environment" {
  description = "Entorno (dev, prod)"
  type        = string
}