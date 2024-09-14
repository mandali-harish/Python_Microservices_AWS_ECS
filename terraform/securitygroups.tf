resource "aws_security_group" "alb_sg"{
    name = "alb_sg-${var.project_name}"
    description = "Security Group for ALB"
    vpc_id = module.vpc.vpc_id
    tags = {
      Name = "alb_sg-${var.project_name}"
    }
    ingress{
        description = "Allow incoming traffic on http port 80"
        from_port = var.http_port
        to_port = var.http_port
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

resource "aws_security_group" "app1_sg"{
    name = "app1_sg-${var.project_name}"
    description = "Security Group for App1"
    vpc_id = module.vpc.vpc_id
    tags = {
      Name = "app1_sg-${var.project_name}"
    }
    ingress{
        description = "Allow incoming traffic on http port 8000"
        from_port = var.app1_port
        to_port = var.app1_port
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
        from_port = var.app2_port
        to_port = var.app2_port
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