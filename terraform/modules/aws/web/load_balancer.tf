resource "aws_alb_target_group" "web" {
  name                 = var.name
  vpc_id               = var.vpc.id
  port                 = 80
  protocol             = "HTTP"
  target_type          = "ip"
  deregistration_delay = 30

  health_check {
    interval            = 30
    path                = "/health"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
    matcher             = 200
  }

  tags = merge(var.common_tags, { Name = format("%s-alb-tg-web", var.name) })
}

resource "aws_alb" "web" {
  name            = var.name
  security_groups = [aws_security_group.alb.id]
  subnets         = var.public_subnets[*].id
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.web.arn
  port              = "80"

  default_action {
    target_group_arn = aws_alb_target_group.web.arn
    type             = "forward"
  }
}

resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_alb.web.arn
  port              = "443"
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = var.certificate.arn

  default_action {
    target_group_arn = aws_alb_target_group.web.arn
    type             = "forward"
  }
}
