output "cloudfront_domain_name" {
  description = "The domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.frontend_distribution.domain_name
}

output "cloudfront_hosted_zone_id" {
  description = "The hosted zone ID for the CloudFront distribution"
  value       = aws_cloudfront_distribution.frontend_distribution.hosted_zone_id
}
