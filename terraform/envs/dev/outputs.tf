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

# S3
output "s3_bucket_name" {
  description = "Bucket S3 del frontend"
  value       = module.cloudfront.s3_bucket_name
}

# CloudWatch
output "cloudwatch_dashboard" {
  description = "Nombre del dashboard de CloudWatch"
  value       = module.cloudwatch.dashboard_name
}

# ECS
output "ecs_log_group" {
  description = "Log group de ECS/Fargate"
  value       = module.cloudwatch.ecs_log_group_name
}

# WAF
output "waf_acl_id" {
  description = "ID del Web ACL de WAF"
  value       = module.waf.web_acl_id
}

# SQS y SNS -------> SNS
output "sns_topic_arn" {
  description = "ARN del tópico SNS para alertas"
  value       = module.sns.sns_topic_arn
}

#output "sqs_queue_url" {
#  description = "URL de la cola SQS"
#  value       = module.sns_sqs.sqs_queue_url
#}

#output "sqs_queue_name" {
#  description = "Nombre de la cola SQS"
#  value       = module.sns_sqs.sqs_queue_name
#}