# ID de la VPC
output "vpc_id" {
  description = "ID de la VPC creada"
  value       = aws_vpc.vpc.id
}

# IDs de subnets públicas
output "public_subnets_ids" {
  description = "IDs de las subnets públicas"
  value       = aws_subnet.public[*].id
}

# IDs de subnets privadas
output "private_subnets_ids" {
  description = "IDs de las subnets privadas"
  value       = aws_subnet.private[*].id
}

# NAT Gateway ID
output "nat_gateway_id" {
  description = "ID del NAT Gateway"
  value       = aws_nat_gateway.nat.id
}