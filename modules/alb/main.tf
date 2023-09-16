resource "aws_lb" "app-lb" {
    name = "app-lb"
    internal = false
    load_balancer_type = "application"
    security_groups = [var.alb_sg]
    subnets = [var.pub_sub_1a_id,var.pub_sub_2b_id]
    enable_deletion_protection = true
    tags = {
      Name = "app-lb"
    }
}

resource "aws_lb_target_group" "alb_target_gp" {
    name = "${var.project_name}-tg"
    port = 80
    protocol = "HTTP"
    target_type = "instance"
    vpc_id = var.vpc_id

    health_check {
      enabled = true
      interval = 300
      path = "/"
      timeout = 60
      matcher = 200
      healthy_threshold = 2
      unhealthy_threshold = 5
    }

    lifecycle {
      create_before_destroy = true
    }
}

# create a listener on port 80 with redirect action
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.app-lb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb_target_gp.arn
  }
}