

resource "aws_lb" "asmaa_lb" {
  name               = "${project_name}-alp"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = [var.private_subnet_ids] # Replace with your subnet IDs

  enable_deletion_protection = false

  tags = {
    Name = "${var.project_name}-alb"
  }
}

resource "aws_lb_target_group" "my_target_group" {
  name     = "${var.project_name}-tg"
  target_type =  "ip"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id # Replace with your VPC ID

  health_check {
    enabled =  true 
    // path: The path is the destination on the target where the ALB sends health check requests. In this example, the ALB will send HTTP requests to the root path ("/") of the target.
    path                = "/"
    protocol            = "HTTP"
    port                = 80
    // healthy_threshold: The number of consecutive successful health checks required for a target to be considered healthy.
    healthy_threshold   = 2
    // unhealthy_threshold: The number of consecutive failed health checks required for a target to be considered unhealthy
    unhealthy_threshold = 2
    // timeout: The amount of time, in seconds, that the ALB waits for a response to each health check request. If no response is received within this time, the health check is considered a failure.
    timeout             = 60
    // interval: The interval, in seconds, between consecutive health checks. In this example, the ALB will perform health checks every 30 seconds.
    interval            = 30
  }
  lifecycle {
    create_before_destroy = true
  }
}


# Create a listner on port 80 (http) with rediredt action 
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.asmaa_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}


# Create a listner on port 443 (https) with forward action 
resource "aws_lb_listener" "alb_https_listener" {
  load_balancer_arn = aws_lb.asmaa_lb.arn
  port              = "443"
  protocol          = "HTTPs"
  
  
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}
