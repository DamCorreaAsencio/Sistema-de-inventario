# IP Set para bloquear IPs específicas (opcional)
resource "aws_wafv2_ip_set" "blocked_ips" {
  name               = "${var.project}-blocked-ips"
  scope              = "CLOUDFRONT" # Para CloudFront debe ser CLOUDFRONT
  ip_address_version = "IPV4"
  addresses          = var.blocked_ip_addresses

  tags = {
    Name        = "${var.project}-blocked-ips"
    Environment = var.environment
  }
}

# Web ACL principal
resource "aws_wafv2_web_acl" "main" {
  name  = "${var.project}-waf-acl"
  scope = "CLOUDFRONT" # CLOUDFRONT o REGIONAL (para ALB)

  default_action {
    allow {}
  }

  # Regla 1: Bloquear IPs específicas
  rule {
    name     = "BlockSpecificIPs"
    priority = 1

    action {
      block {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.blocked_ips.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.project}-blocked-ips-rule"
      sampled_requests_enabled   = true
    }
  }

  # Regla 2: Rate Limiting (protección DDoS)
  rule {
    name     = "RateLimit"
    priority = 2

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = var.rate_limit # Peticiones por 5 minutos
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.project}-rate-limit-rule"
      sampled_requests_enabled   = true
    }
  }

  # Regla 3: AWS Managed Rules - Core Rule Set (protección básica)
  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 3

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesCommonRuleSet"

        # Excluir reglas específicas si causan falsos positivos
        # excluded_rule {
        #   name = "SizeRestrictions_BODY"
        # }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.project}-aws-common-rules"
      sampled_requests_enabled   = true
    }
  }

  # Regla 4: Protección contra ataques de inyección SQL
  rule {
    name     = "AWSManagedRulesSQLiRuleSet"
    priority = 4

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesSQLiRuleSet"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.project}-sqli-rules"
      sampled_requests_enabled   = true
    }
  }

  # Regla 5: Protección contra bots maliciosos
  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 5

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.project}-bad-inputs-rules"
      sampled_requests_enabled   = true
    }
  }

  # Regla 6: Protección contra vulnerabilidades Linux (opcional)
  dynamic "rule" {
    for_each = var.enable_linux_protection ? [1] : []
    content {
      name     = "AWSManagedRulesLinuxRuleSet"
      priority = 6

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          vendor_name = "AWS"
          name        = "AWSManagedRulesLinuxRuleSet"
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "${var.project}-linux-rules"
        sampled_requests_enabled   = true
      }
    }
  }

  # Configuración de visibilidad general
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.project}-waf-acl"
    sampled_requests_enabled   = true
  }

  tags = {
    Name        = "${var.project}-waf"
    Environment = var.environment
  }
}

# Log Configuration para WAF (enviar logs a CloudWatch o S3)
resource "aws_wafv2_web_acl_logging_configuration" "main" {
  count                   = var.enable_logging ? 1 : 0
  resource_arn            = aws_wafv2_web_acl.main.arn
  log_destination_configs = [var.log_destination_arn]

  redacted_fields {
    single_header {
      name = "authorization"
    }
  }
}