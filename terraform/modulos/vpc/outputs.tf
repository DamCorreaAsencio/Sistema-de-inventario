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