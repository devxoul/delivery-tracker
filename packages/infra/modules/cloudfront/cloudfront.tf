locals {
  alb_origin_id = "delivery-tracker-lb"
}

resource "aws_cloudfront_distribution" "alb" {
  origin {
    origin_id   = local.alb_origin_id
    domain_name = var.alb_domain_name

    custom_origin_config {
      origin_protocol_policy = "https-only"
      http_port              = 80
      https_port             = 443
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  enabled         = true
  is_ipv6_enabled = true
  aliases         = [var.domain_name]

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = "arn:aws:acm:us-east-1:599087160579:certificate/ad148be7-4ebe-4b1a-ae6f-0a36ac94743a"
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }

  default_cache_behavior {
    target_origin_id       = local.alb_origin_id
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    cache_policy_id          = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad" # Managed-CachingDisabled
    origin_request_policy_id = "f864aba7-6142-4757-b5ba-849466622f99" # AllViewer-With-CloudFront-Headers
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name        = "delivery-tracker-${var.environment}"
    Description = "delivery-tracker-${var.environment}"
    Project     = "delivery-tracker"
    Environment = var.environment
  }
}
