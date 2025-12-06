# Tópico SNS para publicar alertas // línea1
resource "aws_sns_topic" "alertas" {
  name         = "${var.project}-alertas"
  display_name = "Alertas de ${var.project}"

  tags = {
    Name        = "${var.project}-sns-alertas"
    Environment = var.environment
  }
}

# Política del tópico SNS (permite publicar desde ECS)
resource "aws_sns_topic_policy" "alertas" {
  arn = aws_sns_topic.alertas.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowECSPublish"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = [
          "SNS:Publish"
        ]
        Resource = aws_sns_topic.alertas.arn
      }
    ]
  })
}

# Cola SQS para recibir mensajes de SNS
#resource "aws_sqs_queue" "alertas" {
#  name                       = "${var.project}-alertas-queue"
#  delay_seconds              = 0
#  max_message_size           = 262144  # 256 KB
# message_retention_seconds  = 345600  # 4 días
#  receive_wait_time_seconds  = 10      # Long polling
#  visibility_timeout_seconds = 300     # 5 minutos

  # Dead Letter Queue (mensajes que fallan)
#  redrive_policy = jsonencode({
#    deadLetterTargetArn = aws_sqs_queue.alertas_dlq.arn
#    maxReceiveCount     = 3
#  })

#  tags = {
#    Name        = "${var.project}-sqs-alertas"
#    Environment = var.environment
#  }
#}

# Dead Letter Queue (para mensajes que fallan después de 3 intentos)
#resource "aws_sqs_queue" "alertas_dlq" {
#  name                      = "${var.project}-alertas-dlq"
#  message_retention_seconds = 1209600  # 14 días

#  tags = {
#    Name        = "${var.project}-sqs-alertas-dlq"
#    Environment = var.environment
#  }
#}

# Política de SQS para permitir recibir de SNS
#resource "aws_sqs_queue_policy" "alertas" {
#  queue_url = aws_sqs_queue.alertas.id

#  policy = jsonencode({
#    Version = "2012-10-17"
#    Statement = [
#      {
#        Sid    = "AllowSNSPublish"
#        Effect = "Allow"
#        Principal = {
#          Service = "sns.amazonaws.com"
#        }
#        Action   = "SQS:SendMessage"
#        Resource = aws_sqs_queue.alertas.arn
#        Condition = {
#          ArnEquals = {
#            "aws:SourceArn" = aws_sns_topic.alertas.arn
#          }
#        }
#      }
#    ]
#  })
#}

# =========================================================================
# Suscripción: SNS a SQS
#resource "aws_sns_topic_subscription" "alertas_to_sqs" {
#  topic_arn = aws_sns_topic.alertas.arn
#  protocol  = "sqs"
#  endpoint  = aws_sqs_queue.alertas.arn

  # Filtro de mensajes (opcional)
  # Puedes filtrar por tipo de alerta
#  filter_policy = jsonencode({
#    tipo = ["inventario_bajo", "producto_agotado", "pedido_pendiente"]
#  })
#}

# =========================================================================
# Suscripción adicional para enviar emails directos desde SNS
resource "aws_sns_topic_subscription" "email_alerts" {
  count     = var.admin_email != "" ? 1 : 0
  topic_arn = aws_sns_topic.alertas.arn
  protocol  = "email"
  endpoint  = var.admin_email

  # Nota: AWS enviará un email de confirmación a esta dirección
  # El admin debe confirmar la suscripción haciendo clic en el link
}

# Alarma: Muchos mensajes en DLQ (mensajes fallidos)
#resource "aws_cloudwatch_metric_alarm" "dlq_messages" {
#  alarm_name          = "${var.project}-sqs-dlq-messages"
#  comparison_operator = "GreaterThanThreshold"
#  evaluation_periods  = 1
#  metric_name         = "ApproximateNumberOfMessagesVisible"
#  namespace           = "AWS/SQS"
#  period              = 300
#  statistic           = "Average"
#  threshold           = 5
#  alarm_description   = "Alerta cuando hay mensajes en la Dead Letter Queue"
#  treat_missing_data  = "notBreaching"

#  dimensions = {
#    QueueName = aws_sqs_queue.alertas_dlq.name
#  }

#  alarm_actions = var.sns_monitoring_topic_arn != "" ? [var.sns_monitoring_topic_arn] : []

#  tags = {
#    Name        = "${var.project}-dlq-alarm"
#    Environment = var.environment
#  }
#}

# Alarma: Cola principal muy llena uwu
#resource "aws_cloudwatch_metric_alarm" "queue_depth" {
#  alarm_name          = "${var.project}-sqs-queue-depth"
#  comparison_operator = "GreaterThanThreshold"
#  evaluation_periods  = 2
#  metric_name         = "ApproximateNumberOfMessagesVisible"
#  namespace           = "AWS/SQS"
#  period              = 300
#  statistic           = "Average"
#  threshold           = var.queue_depth_threshold
#  alarm_description   = "Alerta cuando la cola tiene muchos mensajes sin procesar"
#  treat_missing_data  = "notBreaching"

#  dimensions = {
#    QueueName = aws_sqs_queue.alertas.name
#  }

#  alarm_actions = var.sns_monitoring_topic_arn != "" ? [var.sns_monitoring_topic_arn] : []

#  tags = {
#    Name        = "${var.project}-queue-depth-alarm"
#    Environment = var.environment
#  }
#}