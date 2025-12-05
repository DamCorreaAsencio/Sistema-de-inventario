output "ecs_log_group_name" {
  description = "Nombre del log group de ECS"
  value       = aws_cloudwatch_log_group.ecs_logs.name
}

output "ecs_log_group_arn" {
  description = "ARN del log group de ECS"
  value       = aws_cloudwatch_log_group.ecs_logs.arn
}

output "dashboard_name" {
  description = "Nombre del dashboard de CloudWatch"
  value       = aws_cloudwatch_dashboard.main.dashboard_name
}

output "rds_log_groups" {
  description = "Log groups de RDS"
  value = {
    error     = aws_cloudwatch_log_group.rds_error_logs.name
    general   = aws_cloudwatch_log_group.rds_general_logs.name
    slowquery = aws_cloudwatch_log_group.rds_slowquery_logs.name
  }
}