# Zona Hospedada (si no existe, créala manualmente primero)
data "aws_route53_zone" "main" {
  count        = var.domain_name != "" ? 1 : 0
  name         = var.domain_name
  private_zone = false
}

# Registro A para CloudFront (con alias)
resource "aws_route53_record" "cloudfront_a" {
  count   = var.domain_name != "" && var.cloudfront_domain_name != "" ? 1 : 0
  zone_id = data.aws_route53_zone.main[0].zone_id
  name    = var.subdomain != "" ? "${var.subdomain}.${var.domain_name}" : var.domain_name
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}

# Registro AAAA para IPv6
resource "aws_route53_record" "cloudfront_aaaa" {
  count   = var.domain_name != "" && var.cloudfront_domain_name != "" ? 1 : 0
  zone_id = data.aws_route53_zone.main[0].zone_id
  name    = var.subdomain != "" ? "${var.subdomain}.${var.domain_name}" : var.domain_name
  type    = "AAAA"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}

# Registro CNAME para API (opcional)
resource "aws_route53_record" "api_cname" {
  count   = var.domain_name != "" && var.api_subdomain != "" && var.api_gateway_domain != "" ? 1 : 0
  zone_id = data.aws_route53_zone.main[0].zone_id
  name    = "${var.api_subdomain}.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [var.api_gateway_domain]
}

# Health Check para monitoreo (opcional)
resource "aws_route53_health_check" "main" {
  count             = var.enable_health_check && var.cloudfront_domain_name != "" ? 1 : 0
  fqdn              = var.cloudfront_domain_name
  port              = 443
  type              = "HTTPS"
  resource_path     = var.health_check_path
  failure_threshold = 3
  request_interval  = 30

  tags = {
    Name        = "${var.project}-health-check"
    Environment = var.environment
  }
}

# Alarma de CloudWatch para Health Check
resource "aws_cloudwatch_metric_alarm" "health_check_alarm" {
  count               = var.enable_health_check && var.sns_topic_arn != "" ? 1 : 0
  alarm_name          = "${var.project}-route53-health-check-failed"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "HealthCheckStatus"
  namespace           = "AWS/Route53"
  period              = 60
  statistic           = "Minimum"
  threshold           = 1
  alarm_description   = "Alerta cuando el health check falla"
  treat_missing_data  = "breaching"

  dimensions = {
    HealthCheckId = aws_route53_health_check.main[0].id
  }

  alarm_actions = [var.sns_topic_arn]

  tags = {
    Name        = "${var.project}-health-check-alarm"
    Environment = var.environment
  }
}