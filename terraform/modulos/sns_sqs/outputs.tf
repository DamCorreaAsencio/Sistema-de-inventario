output "sns_topic_arn" {
  description = "ARN del tópico SNS"
  value       = aws_sns_topic.alertas.arn
}

output "sns_topic_name" {
  description = "Nombre del tópico SNS"
  value       = aws_sns_topic.alertas.name
}

output "sqs_queue_url" {
  description = "URL de la cola SQS"
  value       = aws_sqs_queue.alertas.url
}

output "sqs_queue_arn" {
  description = "ARN de la cola SQS"
  value       = aws_sqs_queue.alertas.arn
}

output "sqs_queue_name" {
  description = "Nombre de la cola SQS"
  value       = aws_sqs_queue.alertas.name
}

output "sqs_dlq_url" {
  description = "URL de la Queue"
  value       = aws_sqs_queue.alertas_dlq.url
}

output "sqs_dlq_arn" {
  description = "ARN de la Queue"
  value       = aws_sqs_queue.alertas_dlq.arn
}