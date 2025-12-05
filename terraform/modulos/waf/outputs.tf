output "web_acl_id" {
  description = "ID del Web ACL de WAF"
  value       = aws_wafv2_web_acl.main.id
}

output "web_acl_arn" {
  description = "ARN del Web ACL de WAF"
  value       = aws_wafv2_web_acl.main.arn
}

output "web_acl_capacity" {
  description = "Capacidad utilizada del Web ACL"
  value       = aws_wafv2_web_acl.main.capacity
}

output "ip_set_arn" {
  description = "ARN del IP Set"
  value       = aws_wafv2_ip_set.blocked_ips.arn
}