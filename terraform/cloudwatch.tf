resource "aws_cloudwatch_log_group" "app1_log_group" {
    name = "/ecs/app1-task"
    retention_in_days = 1

    tags = {
        Name = "${var.project_name}-log-group"
    }
}

resource "aws_cloudwatch_log_stream" "app1_log_stream" {
    name = "app1-log-stream"
    log_group_name = aws_cloudwatch_log_group.app1_log_group.name
}

resource "aws_cloudwatch_log_group" "app2_log_group" {
    name = "/ecs/app2-task"
    retention_in_days = 1

    tags = {
        Name = "${var.project_name}-log-group"
    }
}

resource "aws_cloudwatch_log_stream" "app2_log_stream" {
    name = "app2-log-stream"
    log_group_name = aws_cloudwatch_log_group.app2_log_group.name
}

resource "aws_sns_topic" "ecs_alerts" {
  name = "ecs-alerts-topic"
}

resource "aws_sns_topic_subscription" "ecs_alert_email_subscription" {
  topic_arn = aws_sns_topic.ecs_alerts.arn
  protocol  = "email"
  endpoint  = "mandali.harish@gmail.com"
}

resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high_app1" {
  alarm_name                = "ecs_cpu_utilization_high_app1"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/ECS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "45"
  alarm_description         = "Alert if ECS service CPU utilization is greater than 45%."
  dimensions = {
    ClusterName = aws_ecs_cluster.python_microservices_cluster.name
    ServiceName = aws_ecs_service.app1_service.name
  }

  alarm_actions = [
    aws_sns_topic.ecs_alerts.arn
  ]
}

resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high_app2" {
  alarm_name                = "ecs_cpu_utilization_high_app2"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/ECS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "45"
  alarm_description         = "Alert if ECS service CPU utilization is greater than 45%."
  dimensions = {
    ClusterName = aws_ecs_cluster.python_microservices_cluster.name
    ServiceName = aws_ecs_service.app2_service.name
  }

  alarm_actions = [
    aws_sns_topic.ecs_alerts.arn
  ]
}