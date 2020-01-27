resource "aws_ses_domain_identity" "main" {
  provider = "aws.oregon"
  domain   = var.domain
}

resource "aws_ses_domain_dkim" "dkim" {
  provider = "aws.oregon"
  domain   = var.domain
}

resource "aws_ses_identity_notification_topic" "bounce" {
  provider                 = "aws.oregon"
  identity                 = aws_ses_domain_identity.main.domain
  notification_type        = "Bounce"
  topic_arn                = aws_sns_topic.ses.arn
  include_original_headers = true
}

resource "aws_ses_identity_notification_topic" "complaint" {
  provider                 = "aws.oregon"
  identity                 = aws_ses_domain_identity.main.domain
  notification_type        = "Complaint"
  topic_arn                = aws_sns_topic.ses.arn
  include_original_headers = true
}
