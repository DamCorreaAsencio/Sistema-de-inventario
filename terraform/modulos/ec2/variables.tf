variable "project" {
  type        = string
  description = "Nombre del proyecto"
}

variable "region" {
  type        = string
  description = "Región AWS"
}

variable "account_id" {
  type        = string
  description = "ID de cuenta AWS"
}

variable "repo_name" {
  type        = string
  description = "Nombre del repositorio ECR"
}

variable "ami_id" {
  type        = string
  description = "AMI de la instancia EC2"
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  type        = string
  description = "Par de claves SSH"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "IDs de las subnets privadas (AZ a y b)"
}

variable "ec2_sg_id" {
  type        = string
  description = "ID del Security Group para EC2"
}

variable "target_group_arn" {
  type        = string
  description = "ARN del Target Group del ALB"
}