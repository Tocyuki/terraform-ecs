# resources
resource "aws_security_group" "rds" {
  name        = "${var.name}-db"
  description = "Controls access to the RDS"
  vpc_id      = var.vpc.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = format("%s-sg-db", var.name) })
}
