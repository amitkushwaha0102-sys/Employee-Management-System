resource "aws_sns_topic" "employee_events" {
  name = "employee-mgmt-events"
}

resource "aws_sns_topic_subscription" "sqs_subscription" {
  topic_arn = aws_sns_topic.employee_events.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.employee_notifications.arn
}

resource "aws_sqs_queue_policy" "allow_sns" {
  queue_url = aws_sqs_queue.employee_notifications.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "sns.amazonaws.com" }
        Action    = "sqs:SendMessage"
        Resource  = aws_sqs_queue.employee_notifications.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.employee_events.arn
          }
        }
      }
    ]
  })
}