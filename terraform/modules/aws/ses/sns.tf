resource "aws_sns_topic" "ses" {
  provider = "aws.oregon"
  name     = "${var.name}-ses-notification"

  tags = merge(var.common_tags, { Name = format("%s-sns-ses-notification", var.name) })
}
