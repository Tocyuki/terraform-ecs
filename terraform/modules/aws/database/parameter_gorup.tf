resource "aws_db_parameter_group" "main" {
  name        = var.name
  family      = local.family
  description = "Database parameter group for ${var.name}"

  tags = merge(var.common_tags, { Name = format("%s-db-param", var.name) })
}
