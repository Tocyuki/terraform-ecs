resource "aws_route53_record" "ses_record" {
  zone_id = var.route53_zone.id
  name    = "_amazonses.${var.domain}"
  type    = "TXT"
  ttl     = "60"
  records = [aws_ses_domain_identity.main.verification_token]
}

resource "aws_route53_record" "dkim_amazone_verification_record" {
  count    = 3
  provider = "aws.oregon"
  zone_id  = var.route53_zone.id
  name     = "${element(aws_ses_domain_dkim.dkim.dkim_tokens, count.index)}._domainkey.${var.domain}"
  type     = "CNAME"
  ttl      = "60"
  records  = ["${element(aws_ses_domain_dkim.dkim.dkim_tokens, count.index)}.dkim.amazonses.com"]
}
