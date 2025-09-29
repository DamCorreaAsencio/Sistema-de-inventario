variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev, prod)"
  type        = string
}

variable "public_subnet_a_cidr" {
  description = "CIDR for public subnet A"
  type        = string
}

variable "public_subnet_b_cidr" {
  description = "CIDR for public subnet B"
  type        = string
}

variable "private_subnet_a_cidr" {
  description = "CIDR for private subnet A"
  type        = string
}

variable "private_subnet_b_cidr" {
  description = "CIDR for private subnet B"
  type        = string
}

variable "az_a" {
  description = "Availability zone A"
  type        = string
}

variable "az_b" {
  description = "Availability zone B"
  type        = string
}