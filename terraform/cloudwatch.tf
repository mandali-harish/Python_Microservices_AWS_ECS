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