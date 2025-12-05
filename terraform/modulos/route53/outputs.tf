output "zone_id" {
  description = "ID de la zona hospedada"
  value       = var.domain_name != "" ? data.aws_route53_zone.main[0].zone_id : ""
}

output "zone_name_servers" {
  description = "Name servers de la zona"
  value       = var.domain_name != "" ? data.aws_route53_zone.main[0].name_servers : []
}

output "frontend_url" {
  description = "URL del frontend"
  value = var.domain_name != "" ? (
    var.subdomain != "" ? "https://${var.subdomain}.${var.domain_name}" : "https://${var.domain_name}"
  ) : ""
}

output "api_url" {
  description = "URL de la API"
  value = var.domain_name != "" && var.api_subdomain != "" ? "https://${var.api_subdomain}.${var.domain_name}" : ""
}

output "health_check_id" {
  description = "ID del health check"
  value       = var.enable_health_check ? aws_route53_health_check.main[0].id : ""
}