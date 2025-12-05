output "rds_endpoint" {
  description = "Endpoint de conexión a RDS"
  value       = aws_db_instance.mysql.endpoint
}

output "rds_address" {
  description = "DNS address de RDS"
  value       = aws_db_instance.mysql.address
}

output "rds_port" {
  description = "Puerto de RDS"
  value       = aws_db_instance.mysql.port
}

output "rds_db_name" {
  description = "Nombre de la base de datos"
  value       = aws_db_instance.mysql.db_name
}

output "rds_arn" {
  description = "ARN de la instancia RDS"
  value       = aws_db_instance.mysql.arn
}