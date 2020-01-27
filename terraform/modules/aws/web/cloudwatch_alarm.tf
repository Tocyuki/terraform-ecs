resource "aws_cloudwatch_metric_alarm" "web_cpu" {
  alarm_name        = "${var.ecs_cluster.name}-${aws_ecs_service.web.name}-cpu"
  alarm_description = "This metric monitors ecs cpu utilization"

  metric_name = "CPUUtilization"
  namespace   = "AWS/ECS"

  dimensions = {
    ClusterName = var.ecs_cluster.name
    ServiceName = aws_ecs_service.web.name
  }

  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "80"
  statistic           = "Average"
  evaluation_periods  = "1"
  period              = "300"

  ok_actions                = [aws_sns_topic.alarm.arn]
  alarm_actions             = [aws_sns_topic.alarm.arn]
  insufficient_data_actions = [aws_sns_topic.alarm.arn]
}

resource "aws_cloudwatch_metric_alarm" "web_memory" {
  alarm_name        = "${var.ecs_cluster.name}-${aws_ecs_service.web.name}-memory"
  alarm_description = "This metric monitors ecs memory utilization"

  metric_name = "MemoryUtilization"
  namespace   = "AWS/ECS"

  dimensions = {
    ClusterName = var.ecs_cluster.name
    ServiceName = aws_ecs_service.web.name
  }

  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "80"
  statistic           = "Average"
  evaluation_periods  = "1"
  period              = "300"

  ok_actions                = [aws_sns_topic.alarm.arn]
  alarm_actions             = [aws_sns_topic.alarm.arn]
  insufficient_data_actions = [aws_sns_topic.alarm.arn]
}
