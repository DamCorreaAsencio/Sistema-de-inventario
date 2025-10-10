# API Gateway para exponer el backend (ALB)
# Crear el API Gateway REST
resource "aws_api_gateway_rest_api" "api" {
  name        = "${var.project}-api"
  description = "API Gateway para ${var.project}"
}

# Recurso raíz (por ejemplo, /api)
resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "api"
}

# Método GET (puede duplicarse para POST, PUT, DELETE)
resource "aws_api_gateway_method" "api_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.api_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

# Integración con ALB 
resource "aws_api_gateway_integration" "api_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.api_resource.id
  http_method             = aws_api_gateway_method.api_method.http_method
  integration_http_method = "GET"
  type                    = "HTTP"
  uri                     = "http://${var.alb_dns_name}/"   # ALB DNS desde módulo alb
}

# Deployment (versión del API)
resource "aws_api_gateway_deployment" "api_deploy" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  depends_on = [aws_api_gateway_integration.api_integration]
}

# Stage (asociación del deployment a un entorno)
resource "aws_api_gateway_stage" "api_stage" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.api_deploy.id
  stage_name    = var.stage_name
}