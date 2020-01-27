resource "aws_db_subnet_group" "main" {
  name        = var.name
  description = "Database Subnet Group for ${var.name}"
  subnet_ids  = var.private_subnets[*].id

  tags = merge(var.common_tags, { Name = format("%s-db-subnet", var.name) })
}
