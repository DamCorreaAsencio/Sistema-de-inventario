# ID de la VPC
output "vpc_id" {
  description = "ID de la VPC creada"
  value       = aws_vpc.vpc.id
}

output "public_subnet_id" {
  description = "Subnet pública (ALB)"
  value       = aws_subnet.public_alb.id
}

output "private_subnets_ids" {
  description = "Subnets privadas (EC2)"
  value       = [aws_subnet.private_ec2_a.id, aws_subnet.private_ec2_b.id]
}

output "rds_subnet_id" {
  description = "Subnet privada RDS"
  value       = aws_subnet.private_rds.id
}

output "vpc_cidr" {
  description = "CIDR VPC"
  value       = aws_vpc.vpc.cidr_block
}