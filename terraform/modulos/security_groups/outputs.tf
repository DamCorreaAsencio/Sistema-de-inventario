output "alb_sg_id" {
  description = "ID del Security Group del ALB"
  value       = aws_security_group.alb_sg.id
}

output "ec2_sg_id" {
  description = "ID del Security Group de las EC2"
  value       = aws_security_group.ec2_sg.id
}

output "rds_sg_id" {
  description = "ID del Security Group del RDS"
  value       = aws_security_group.rds_sg.id
}

output "endpoint_sg_id" {
  description = "ID del Security Group para VPC Endpoints"
  value       = aws_security_group.endpoint_sg.id
}