output "cloudfront_oai" {
  value       = aws_cloudfront_origin_access_identity.oai
  description = "The entire CloudFront Origin Access Identity resource"
}
