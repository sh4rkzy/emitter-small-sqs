
resource "aws_sqs_queue" "logistics_events_queue" {
  name                          = "logistics-events-queue.fifo"
  fifo_queue                    = true
  content_based_deduplication   = true
  visibility_timeout_seconds    = 30
  deduplication_scope           = "messageGroup"
  fifo_throughput_limit         = "perQueue"

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.logistics_events_dlq.arn
    maxReceiveCount     = 4
  })
}

resource "aws_sqs_queue" "logistics_events_dlq" {
  name                          = "logistics-events-deadletter-queue.fifo"
  fifo_queue                    = true
  content_based_deduplication   = true
}

resource "aws_sqs_queue_redrive_allow_policy" "allow_redrive_dlq" {
  queue_url = aws_sqs_queue.logistics_events_dlq.id

  redrive_allow_policy = jsonencode({
    redrivePermission = "Allow",
    sourceQueueArns   = [aws_sqs_queue.logistics_events_queue.arn]
  })
}
