output "zone_id" {
  value = aws_cloudfront_distribution.alb.hosted_zone_id
}

output "domain_name" {
  value = aws_cloudfront_distribution.alb.domain_name
}
