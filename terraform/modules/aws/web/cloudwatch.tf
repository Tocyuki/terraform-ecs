resource "aws_cloudwatch_log_group" "web" {
  name = "${var.name}-web"

  tags = merge(var.common_tags, { Name = format("%s-cw-log", var.name) })
}
