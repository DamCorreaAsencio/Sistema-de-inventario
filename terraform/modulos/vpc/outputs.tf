output "vpc_id" {
  description = "ID - VPC"
  value       = aws_vpc.vpc.id
}


/*output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "private_subnets" {
  value = aws_subnet.private[*].id
}*/