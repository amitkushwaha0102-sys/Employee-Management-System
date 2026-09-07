resource "aws_sns_topic" "alarms" {
  name = "employee-mgmt-alarms"
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "employee-mgmt-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 70

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app.name
  }

  alarm_actions = [aws_sns_topic.alarms.arn]

  tags = {
    Name = "employee-mgmt-high-cpu-alarm"
  }
}

resource "aws_cloudwatch_metric_alarm" "alb_5xx_errors" {
  alarm_name          = "employee-mgmt-alb-5xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 5

  dimensions = {
    LoadBalancer = aws_lb.main.arn_suffix
  }

  alarm_actions = [aws_sns_topic.alarms.arn]

  tags = {
    Name = "employee-mgmt-alb-5xx-alarm"
  }
}