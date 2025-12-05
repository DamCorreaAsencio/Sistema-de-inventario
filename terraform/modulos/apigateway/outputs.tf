# Salida: URL pública del API Gateway
output "api_gateway_url" {
  description = "URL pública del API Gateway"
  value       = "https://${aws_api_gateway_rest_api.api.id}.execute-api.${var.region}.amazonaws.com/${var.stage_name}/api"
}
output "api_gateway_domain" {
  description = "Dominio del API Gateway (sin https://)"
  value       = "${aws_api_gateway_rest_api.api.id}.execute-api.${var.region}.amazonaws.com"
}