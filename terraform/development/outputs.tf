output "sqs_queue_url" {
  value = aws_sqs_queue.logistics_events_queue.id
}

output "sqs_dlq_url" {
  value = aws_sqs_queue.logistics_events_dlq.id
}

output "iam_user_access_key" {
  value = aws_iam_access_key.tracking_user_key.id
}

output "iam_user_secret_key" {
  value     = aws_iam_access_key.tracking_user_key.secret
  sensitive = true
}
