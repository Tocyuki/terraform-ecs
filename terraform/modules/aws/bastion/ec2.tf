resource "aws_instance" "bastion" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = element(var.public_subnets[*].id, 0)
  key_name                    = var.key_pair.key_name
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true

  tags = merge(var.common_tags, { Name = format("%s-bastion", var.name) })
}

resource "aws_eip" "bastion" {
  instance = aws_instance.bastion.id
  vpc      = true
}
