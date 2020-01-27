resource "aws_security_group" "web" {
  name        = "${var.name}-ecs-service-web"
  description = "ECS service for ${var.name} web"
  vpc_id      = var.vpc.id

  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = format("%s-sg-ecs-service-web", var.name) })
}

resource "aws_security_group" "alb" {
  name        = "${var.name}-alb-web"
  description = "ALB for ${var.name} web"
  vpc_id      = var.vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = format("%s-sg-alb-web", var.name) })
}
