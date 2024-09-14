resource "aws_service_discovery_private_dns_namespace" "apps_dns_discovery" {
  name        = "${var.project_name}-dns"
  description = "dns discovery"
  vpc         = module.vpc.vpc_id
}

resource "aws_service_discovery_service" "app1_discovery_service" {
  name = "app1-sd"

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

resource "aws_service_discovery_service" "app2_discovery_service" {
  name = "app2-sd"

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
