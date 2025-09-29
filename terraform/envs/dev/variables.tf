variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "aws_profile" {
  description = "AWS profile"
  type        = string
  default     = "CarlosAS" //cambiar con su usuario (IAM)
}