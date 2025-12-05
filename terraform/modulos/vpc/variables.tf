# Nombre del proyecto (para tags)
variable "project" {
  description = "sistema d einventario-vpc"
  type        = string
}

variable "region" {
  description = "Región AWS"
  type        = string
}

# CIDR principal de la VPC
variable "vpc_cidr" {
  description = "CIDR de la VPC"
  type        = string
}

variable "public_subnet_a_cidr" {
  description = "CIDR de la subnet pública A"
  type        = string
}

variable "public_subnet_b_cidr" {
  description = "CIDR de la subnet pública B"
  type        = string
}

variable "private_subnet_ec2_a_cidr" {
  description = "CIDR subnet privada EC2 AZ-a"
  type        = string
}

variable "private_subnet_ec2_b_cidr" {
  description = "CIDR subnet privada EC2 AZ-b"
  type        = string
}

variable "private_subnet_rds_cidr" {
  description = "CIDR subnet privada para RDS"
  type        = string
}

variable "az_a" {
  description = "Availability Zone A"
  type        = string
}

variable "az_b" {
  description = "Availability Zone B"
  type        = string
}
variable "endpoint_sg_id" {
  description = "Security Group para los endpoints de VPC"
  type        = string
}