# ID de la VPC
output "vpc_id" {
  description = "ID de la VPC creada"
  value       = aws_vpc.vpc.id
}

output "public_subnets_ids" {
  description = "Subnets públicas (ALB)"
  value       = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]
}

output "private_subnets_ids" {
  description = "Subnets privadas (EC2 con fargate)"
  value       = [aws_subnet.private_ec2_a.id, aws_subnet.private_ec2_b.id]
}

output "rds_subnet_ids" {
  description = "Subnets privadas para RDS"
  value       = [aws_subnet.private_rds.id, aws_subnet.private_rds_b.id]
}

output "vpc_cidr" {
  description = "CIDR VPC"
  value       = aws_vpc.vpc.cidr_block
}

output "internet_gateway_id" {
  description = "ID del Internet Gateway"
  value       = aws_internet_gateway.igw.id
}