variable "project_name"{
    type = string
    default = "python-microservices"
    description = "Project Name"
}
variable "aws_region" {
    type = string
    description = "AWS region"
    default = "eu-central-1"
}
variable "health_check_path" {
    default = "/get/send/health"
}

variable "app1_port" {
    default = 8000
    description = "App1 exposed port number"
}

variable "app2_port" {
    default = 8001
    description = "App2 exposed port number"
}

variable "fargate_cpu"{
    default = "1024"
}

variable "fargate_memory"{
    default = "2048"
}

variable "app_count"{
    default = "1"
}

variable "private_dns_namespace"{
    default = "python-microservices-apps"
}

variable "app1_service"{
    default = "app1-service"
}
variable "app2_service"{
    default = "app2-service"
}