locals {
  zone_id = "Z7UBWEFJRSMF5" # indentcorp.com
}

resource "aws_route53_record" "cloudfront" {
  zone_id = local.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    zone_id                = var.cloudfront_zone_id
    name                   = var.cloudfront_domain_name
    evaluate_target_health = true
  }
}
