resource "aws_ecs_cluster" "main" {
  name = var.name

  tags = merge(var.common_tags, { Name = format("%s-cluster", var.name) })
}
