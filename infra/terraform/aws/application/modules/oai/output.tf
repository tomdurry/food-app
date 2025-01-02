output "oai_cloudfront_access_identity_path" {
  value       = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
  description = "The CloudFront origin access identity path"
}

output "oai_iam_arn" {
  value       = aws_cloudfront_origin_access_identity.oai.iam_arn
  description = "The ARN of the IAM associated with the CloudFront origin access identity"
}
