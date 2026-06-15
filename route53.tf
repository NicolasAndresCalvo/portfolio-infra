data "aws_route53_zone" "site" {
  name         = "${var.domain_name}."
  private_zone = false
}

# Apex and www both alias to CloudFront (Z2FDTNDATAQYW2 is CloudFront's fixed zone id).
locals {
  cloudfront_zone_id = "Z2FDTNDATAQYW2"
}

resource "aws_route53_record" "apex_a" {
  zone_id = data.aws_route53_zone.site.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.site.domain_name
    zone_id                = local.cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "apex_aaaa" {
  zone_id = data.aws_route53_zone.site.zone_id
  name    = var.domain_name
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.site.domain_name
    zone_id                = local.cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_a" {
  zone_id = data.aws_route53_zone.site.zone_id
  name    = local.www_domain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.site.domain_name
    zone_id                = local.cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_aaaa" {
  zone_id = data.aws_route53_zone.site.zone_id
  name    = local.www_domain
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.site.domain_name
    zone_id                = local.cloudfront_zone_id
    evaluate_target_health = false
  }
}
