# VPC
output "vpc_id" {
  value = module.vpc.vpc_id
}

# ALB
output "alb_dns_name" {
  description = "DNS del Application Load Balancer"
  value       = module.alb.alb_dns_name
}

# API Gateway
output "api_gateway_url" {
  description = "URL del API Gateway"
  value       = module.apigateway.api_gateway_url
}

# RDS
output "rds_endpoint" {
  description = "Endpoint de la base de datos"
  value       = module.rds.rds_endpoint
  sensitive   = true
}

# CloudFront
output "cloudfront_url" {
  description = "URL de CloudFront para el frontend"
  value       = module.cloudfront.cloudfront_url
}

output "s3_bucket_name" {
  description = "Bucket S3 del frontend"
  value       = module.cloudfront.s3_bucket_name
}

# CloudWatch
output "cloudwatch_dashboard" {
  description = "Nombre del dashboard de CloudWatch"
  value       = module.cloudwatch.dashboard_name
}

output "ecs_log_group" {
  description = "Log group de ECS/Fargate"
  value       = module.cloudwatch.ecs_log_group_name
}

# WAF
output "waf_acl_id" {
  description = "ID del Web ACL de WAF"
  value       = module.waf.web_acl_id
}