resource "aws_appautoscaling_target" "ecs_target_app1" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.python_microservices_cluster.name}/${aws_ecs_service.app1_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy_app1" {
  name               = "ECS_App1_Capacity_Utilization"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target_app1.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target_app1.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target_app1.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 80
  }
}

resource "aws_appautoscaling_target" "ecs_target_app2" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.python_microservices_cluster.name}/${aws_ecs_service.app2_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy_app2" {
  name               = "ECS_App2_Capacity_Utilization"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target_app2.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target_app2.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target_app2.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 80
  }
}