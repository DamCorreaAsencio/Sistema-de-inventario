output "vpc_id" {
  description = "ID - VPC"
  value       = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  description = "IDs de las subredes públicas"
  value = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]
}

output "private_subnet_ids" {
  description = "IDs de las subredes privadas"
  value = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]
}

output "nat_gateway_id" {
  description = "ID del NAT Gateway"
  value       = aws_nat_gateway.nat.id
}

output "private_route_table_id" {
  description = "ID de la Route Table Privada"
  value       = aws_route_table.private.id
}