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
output "listener_arn" {
  value = aws_lb_listener.http.arn
}
output "alb_arn_suffix" {
  description = "ARN suffix del ALB para métricas de CloudWatch"
  value       = aws_lb.this.arn_suffix
}