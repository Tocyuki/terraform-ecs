resource "aws_security_group" "bastion" {
  name        = "${var.name}-bastion"
  description = "Bastion security group for ${var.name}"
  vpc_id      = var.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = format("%s-sg-bastion", var.name) })
}
