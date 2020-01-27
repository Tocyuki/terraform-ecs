resource "aws_acm_certificate" "web" {
  domain_name       = var.domain
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.common_tags, { Name = format("%s-acm-web", var.name) })
}

resource "aws_route53_record" "cert_validation_web" {
  zone_id = var.route53_zone.id
  ttl     = 60

  name    = aws_acm_certificate.web.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.web.domain_validation_options[0].resource_record_type
  records = [aws_acm_certificate.web.domain_validation_options[0].resource_record_value]
}

resource "aws_acm_certificate_validation" "web" {
  certificate_arn         = aws_acm_certificate.web.arn
  validation_record_fqdns = [aws_route53_record.cert_validation_web.fqdn]
}

