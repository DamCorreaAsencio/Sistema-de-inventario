output "alb_arn" {
  description = "ARN del ALB"
  value       = aws_lb.this.arn
}

output "alb_dns_name" {
  description = "DNS público del ALB"
  value       = aws_lb.this.dns_name
}

output "target_group_arn" {
  description = "ARN del Target Group asociado al backend"
  value       = aws_lb_target_group.this.arn
}