variable "project_name"{
    default = "python-microservices"
    description = "Project Name"
}

variable "aws_region" {
    description = "AWS region"
    default = "eu-central-1"
}

variable "app1_port" {
    default = 8000
    description = "App1 port number"
}

variable "app2_port" {
    default = 8001
    description = "App2 port number"
}

variable "http_port" {
    default = 80
    description = "HTTP port number"
}

variable "fargate_cpu"{
    default = "512"
}

variable "fargate_memory"{
    default = "1024"
}

variable "app1_cpu"{
    default = 512
}

variable "app1_memory"{
    default = 1024
}

variable "app2_cpu"{
    default = 512
}

variable "app2_memory"{
    default = 1024
}

variable "app_desired_count" {
    default = 1
}
