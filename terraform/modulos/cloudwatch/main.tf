# Log Group para ECS/Fargate
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/${var.project}"
  retention_in_days = var.log_retention_days

  tags = {
    Name        = "${var.project}-ecs-logs"
    Environment = var.environment
  }
}

# Log Group para RDS
resource "aws_cloudwatch_log_group" "rds_error_logs" {
  name              = "/aws/rds/instance/${var.project}-mysql/error"
  retention_in_days = var.log_retention_days

  tags = {
    Name        = "${var.project}-rds-error-logs"
    Environment = var.environment
  }
}

resource "aws_cloudwatch_log_group" "rds_general_logs" {
  name              = "/aws/rds/instance/${var.project}-mysql/general"
  retention_in_days = var.log_retention_days

  tags = {
    Name        = "${var.project}-rds-general-logs"
    Environment = var.environment
  }
}

resource "aws_cloudwatch_log_group" "rds_slowquery_logs" {
  name              = "/aws/rds/instance/${var.project}-mysql/slowquery"
  retention_in_days = var.log_retention_days

  tags = {
    Name        = "${var.project}-rds-slowquery-logs"
    Environment = var.environment
  }
}

# Alarma: Alta utilización de CPU en ECS
resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high" {
  alarm_name          = "${var.project}-ecs-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = var.ecs_cpu_threshold
  alarm_description   = "Alerta cuando CPU de ECS supera ${var.ecs_cpu_threshold}%"
  treat_missing_data  = "notBreaching"

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }

  alarm_actions = var.sns_topic_arn != "" ? [var.sns_topic_arn] : []

  tags = {
    Name        = "${var.project}-ecs-cpu-alarm"
    Environment = var.environment
  }
}

# Alarma: Alta utilización de memoria en ECS
resource "aws_cloudwatch_metric_alarm" "ecs_memory_high" {
  alarm_name          = "${var.project}-ecs-memory-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = var.ecs_memory_threshold
  alarm_description   = "Alerta cuando memoria de ECS supera ${var.ecs_memory_threshold}%"
  treat_missing_data  = "notBreaching"

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }

  alarm_actions = var.sns_topic_arn != "" ? [var.sns_topic_arn] : []

  tags = {
    Name        = "${var.project}-ecs-memory-alarm"
    Environment = var.environment
  }
}

# Alarma: Alta utilización de CPU en RDS
resource "aws_cloudwatch_metric_alarm" "rds_cpu_high" {
  alarm_name          = "${var.project}-rds-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = var.rds_cpu_threshold
  alarm_description   = "Alerta cuando CPU de RDS supera ${var.rds_cpu_threshold}%"
  treat_missing_data  = "notBreaching"

  dimensions = {
    DBInstanceIdentifier = var.rds_instance_id
  }

  alarm_actions = var.sns_topic_arn != "" ? [var.sns_topic_arn] : []

  tags = {
    Name        = "${var.project}-rds-cpu-alarm"
    Environment = var.environment
  }
}

# Alarma: Poco espacio libre en RDS
resource "aws_cloudwatch_metric_alarm" "rds_storage_low" {
  alarm_name          = "${var.project}-rds-storage-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = var.rds_storage_threshold # En bytes (5GB = 5368709120)
  alarm_description   = "Alerta cuando el espacio libre en RDS es bajo"
  treat_missing_data  = "notBreaching"

  dimensions = {
    DBInstanceIdentifier = var.rds_instance_id
  }

  alarm_actions = var.sns_topic_arn != "" ? [var.sns_topic_arn] : []

  tags = {
    Name        = "${var.project}-rds-storage-alarm"
    Environment = var.environment
  }
}

# Alarma: ALB con muchos errores 5xx
resource "aws_cloudwatch_metric_alarm" "alb_5xx_errors" {
  alarm_name          = "${var.project}-alb-5xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = var.alb_5xx_threshold
  alarm_description   = "Alerta cuando hay muchos errores 5xx en ALB"
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
  }

  alarm_actions = var.sns_topic_arn != "" ? [var.sns_topic_arn] : []

  tags = {
    Name        = "${var.project}-alb-5xx-alarm"
    Environment = var.environment
  }
}

# Dashboard de CloudWatch
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/ECS", "CPUUtilization", { stat = "Average", label = "ECS CPU" }],
            [".", "MemoryUtilization", { stat = "Average", label = "ECS Memory" }]
          ]
          period = 300
          region = var.region
          title  = "ECS Metrics"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/RDS", "CPUUtilization", { stat = "Average", label = "RDS CPU" }],
            [".", "DatabaseConnections", { stat = "Average", label = "DB Connections" }],
            [".", "FreeStorageSpace", { stat = "Average", label = "Free Storage" }]
          ]
          period = 300
          region = var.region
          title  = "RDS Metrics"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", { stat = "Sum", label = "Requests" }],
            [".", "HTTPCode_Target_5XX_Count", { stat = "Sum", label = "5xx Errors" }],
            [".", "TargetResponseTime", { stat = "Average", label = "Response Time" }]
          ]
          period = 60
          region = var.region
          title  = "ALB Metrics"
        }
      }
    ]
  })
}