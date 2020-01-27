resource "aws_ssm_parameter" "app_facebook_key" {
  name        = "${var.name}-app-facebook-key"
  description = "Facebook Key for ${var.name}"
  type        = "String"
  value       = var.facebook_key

  tags = merge(var.common_tags, { Name = format("%s-param-app-facebook-key", var.name) })
}

resource "aws_ssm_parameter" "app_facebook_secret" {
  name        = "${var.name}-app-facebook-secret"
  description = "Facebook Secret for ${var.name}"
  type        = "SecureString"
  value       = var.facebook_secret

  tags = merge(var.common_tags, { Name = format("%s-param-app-facebook-secret", var.name) })
}

resource "aws_ssm_parameter" "app_bugsnag_api_key" {
  name        = "${var.name}-app-bugsnag-api-key"
  description = "Bugsnag API Key for ${var.name}"
  type        = "String"
  value       = var.bugsnag_api_key

  tags = merge(var.common_tags, { Name = format("%s-param-app-bugsnag-api-key", var.name) })
}
