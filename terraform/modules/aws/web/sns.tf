resource "aws_sns_topic" "alarm" {
  name = "${var.name}-web-alarm"

  tags = merge(var.common_tags, { Name = format("%s-sns-web-alarm", var.name) })
}
