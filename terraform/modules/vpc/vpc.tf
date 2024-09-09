module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.project_name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

resource "aws_security_group" "app1_sg"{
    name = "app1_sg-${var.project_name}"
    description = "Security Group for App1"
    vpc_id = module.vpc.vpc_id
    tags = {
      Name = "app1_sg-${var.project_name}"
    }
    ingress{
        description = "Allow incoming traffic on http port 8000"
        from_port = 8000
        to_port = 8000
        protocol = "tcp"
        security_groups = [aws_security_group.alb_sg.id]
    }

    egress{
        description = "Allow all outgoing traffic"
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }

}

resource "aws_security_group" "app2_sg"{
    name = "app2_sg-${var.project_name}"
    description = "Security Group for App2"
    vpc_id = module.vpc.vpc_id
    tags = {
      Name = "app2_sg-${var.project_name}"
    }
    ingress{
        description = "Allow incoming traffic on http port 8001"
        from_port = 8001
        to_port = 8001
        protocol = "tcp"
        security_groups = [aws_security_group.app1_sg.id]
    }

    egress{
        description = "Allow all outgoing traffic"
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }

}

resource "aws_security_group" "alb_sg"{
    name = "alb_sg-${var.project_name}"
    description = "Security Group for ALB"
    vpc_id = module.vpc.vpc_id
    tags = {
      Name = "alb_sg-${var.project_name}"
    }
    ingress{
        description = "Allow incoming traffic on http port 80"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    egress{
        description = "Allow all outgoing traffic"
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }

}
