output "cloudfront_certificate_arn" {
  description = "The ARN of the ACM certificate"
  value       = aws_acm_certificate.cloudfront_certificate.arn
}

output "lb_certificate_arn" {
  description = "The ARN of the ACM certificate"
  value       = aws_acm_certificate.lb_certificate.arn
}

output "cloudfront_domain_validation_options" {
  value = aws_acm_certificate.cloudfront_certificate.domain_validation_options
}

output "lb_domain_validation_options" {
  value = aws_acm_certificate.lb_certificate.domain_validation_options
}
