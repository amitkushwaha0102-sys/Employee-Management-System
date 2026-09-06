resource "aws_sqs_queue" "employee_notifications_dlq" {
  name = "employee-mgmt-notifications-dlq"
}

resource "aws_sqs_queue" "employee_notifications" {
  name = "employee-mgmt-notifications"

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.employee_notifications_dlq.arn
    maxReceiveCount     = 3
  })
}
