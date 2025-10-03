variable "ami_id" {
  description = "AMI para EC2 (Amazon Linux 2)"
  type        = string
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  default     = "t3.micro"
}

variable "key_name" {
  description = "Llave SSH"
  type        = string
}

variable "security_group_id" {
  description = "Security Group para backend"
  type        = string
}

variable "subnet_ids" {
  description = "Lista de subredes privadas"
  type        = list(string)
}
