resource "aws_ecs_cluster" "python_microservices_cluster" {
  name = "${var.project_name}-cluster"

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}


resource "aws_ecs_task_definition" "app1_def" {
  family = "app1-task"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = var.fargate_cpu
  memory = var.fargate_memory
  container_definitions = jsonencode([
    {
      name      = "app1"
      image     = "registry.gitlab.com/liveeo-challenge/harish-kumar-mandali:latest-app1"
      cpu       = var.app1_cpu
      memory    = var.app1_memory
      essential = true
      portMappings = [
        {
          name = "app1_port"
          containerPort = var.app1_port
          hostPort      = var.app1_port
          protocol = "tcp"
          appProtocol = "http"
        }
      ]
      repositoryCredentials = {
        credentialsParameter = "arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:gitlab-hm-adZam3"
      }
      environment = [
        {
          name = "APP2_URL",
          value = "http://${aws_service_discovery_service.app2_discovery_service.name}.${aws_service_discovery_private_dns_namespace.apps_dns_discovery.name}:${var.app2_port}/api2/send/"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
            awslogs-group = "/ecs/app1-task"
            awslogs-region = var.aws_region
            awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_task_definition" "app2_def" {
  family = "app2-task"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = var.fargate_cpu
  memory = var.fargate_memory
  container_definitions = jsonencode([
    {
      name      = "app2"
      image     = "registry.gitlab.com/liveeo-challenge/harish-kumar-mandali:latest-app2"
      cpu       = var.app2_cpu
      memory    = var.app2_memory
      essential = true
      portMappings = [
        {
          name = "app2_port"
          containerPort = var.app2_port
          hostPort      = var.app2_port
          protocol = "tcp"
          appProtocol = "http"
        }
      ]
      repositoryCredentials = {
        credentialsParameter = "arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:gitlab-hm-adZam3"
      }
      logConfiguration = {
        logDriver = "awslogs"
        options = {
            awslogs-group = "/ecs/app2-task"
            awslogs-region = var.aws_region
            awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}


resource "aws_ecs_service" "app1_service" {
  name = "app1-service"
  cluster = aws_ecs_cluster.python_microservices_cluster.id
  task_definition = aws_ecs_task_definition.app1_def.arn
  desired_count = var.app_desired_count
  launch_type = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.app1_sg.id]
    subnets = module.vpc.private_subnets
  }
  load_balancer {
    target_group_arn = aws_alb_target_group.app1_tg.arn
    container_name = "app1"
    container_port = var.app1_port
  }

  service_registries {
    registry_arn = aws_service_discovery_service.app1_discovery_service.arn
  }

  depends_on = [aws_alb_listener.app1_listener, aws_iam_role_policy_attachment.ecs_task_execution_role,aws_ecs_service.app2_service]
}

resource "aws_ecs_service" "app2_service" {
  name = "app2-service"
  cluster = aws_ecs_cluster.python_microservices_cluster.id
  task_definition = aws_ecs_task_definition.app2_def.arn
  desired_count = var.app_desired_count
  launch_type = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.app2_sg.id]
    subnets = module.vpc.private_subnets
  }

  service_registries {
    registry_arn = aws_service_discovery_service.app2_discovery_service.arn
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_role]
}
