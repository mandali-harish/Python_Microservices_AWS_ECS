resource "aws_ecs_cluster" "python-microservices-cluster" {
  name = "python-microservices-cluster"

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

resource "aws_service_discovery_private_dns_namespace" "apps_dns_discovery" {
  name        = var.private_dns_namespace
  description = "dns discovery"
  vpc         = module.vpc.vpc_id
}

resource "aws_ecs_task_definition" "app1-def" {
  family = "app1-task"
  execution_role_arn = aws_iam_role.ecs-task-execution-role.arn
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = var.fargate_cpu
  memory = var.fargate_memory
  container_definitions = jsonencode([
    {
      name      = "app1"
      image     = "registry.gitlab.com/devops1664834/test:latest-app1"
      cpu       = 1024
      memory    = 2048
      essential = true
      environment = [
        {
          name = "APP2_URL",
          value = "http://${aws_service_discovery_service.app2-discovery-service.name}.${aws_service_discovery_private_dns_namespace.apps_dns_discovery.name}:${var.app2_port}/api2/send/"
        }
      ]
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
        credentialsParameter = "arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:gitlab-access-YQYr0I"
      }
    }
  ])
}

resource "aws_ecs_service" "app1-service" {
  name = "app1-service"
  cluster = aws_ecs_cluster.python-microservices-cluster.id
  task_definition = aws_ecs_task_definition.app1-def.arn
  desired_count = var.app_count
  launch_type = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.app1_sg.id]
    subnets = module.vpc.private_subnets
    #assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_alb_target_group.app1-tg.arn
    container_name = "app1"
    container_port = var.app1_port
  }

  service_registries {
    registry_arn = aws_service_discovery_service.app1-discovery-service.arn
  }

  depends_on = [aws_alb_listener.app1-listener, aws_iam_role_policy_attachment.ecs-task-execution-role,aws_ecs_service.app2-service]
}


resource "aws_service_discovery_service" "app1-discovery-service" {
  name = var.app1_service

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.apps_dns_discovery.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 2
  }
}


resource "aws_ecs_task_definition" "app2-def" {
  family = "app2-task"
  execution_role_arn = aws_iam_role.ecs-task-execution-role.arn
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = var.fargate_cpu
  memory = var.fargate_memory
  container_definitions = jsonencode([
    {
      name      = "app2"
      image     = "registry.gitlab.com/devops1664834/test:latest-app2"
      cpu       = 1024
      memory    = 2048
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
        credentialsParameter = "arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:gitlab-access-YQYr0I"
      }
    }
  ])
}

resource "aws_ecs_service" "app2-service" {
  name = "app2-service"
  cluster = aws_ecs_cluster.python-microservices-cluster.id
  task_definition = aws_ecs_task_definition.app2-def.arn
  desired_count = var.app_count
  launch_type = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.app2_sg.id]
    subnets = module.vpc.private_subnets
    #assign_public_ip = true
  }

  service_registries {
    registry_arn = aws_service_discovery_service.app2-discovery-service.arn
  }

  depends_on = [aws_iam_role_policy_attachment.ecs-task-execution-role]
}

resource "aws_service_discovery_service" "app2-discovery-service" {
  name = var.app2_service

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.apps_dns_discovery.id
    dns_records {
      ttl = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 2
  }

}