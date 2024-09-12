resource "aws_alb" "app1-alb"{
    name = "app1-load-balancer"
    load_balancer_type = "application"
    subnets = module.vpc.public_subnets
    security_groups = [aws_security_group.alb_sg.id]
}

resource "aws_alb_target_group" "app1-tg"{
    name = "app1-target-group"
    port = 80
    protocol = "HTTP"
    target_type = "ip"
    vpc_id = module.vpc.vpc_id

    health_check {
        healthy_threshold = 2
        unhealthy_threshold = 2
        timeout = 3
        protocol = "HTTP"
        matcher = "200"
        path = var.health_check_path
        interval = 30
    }
}

resource "aws_alb_listener" "app1-listener" {
    load_balancer_arn = aws_alb.app1-alb.id
    port = 80
    protocol = "HTTP"

    default_action {
        type = "forward"
        target_group_arn = aws_alb_target_group.app1-tg.arn
    }
}