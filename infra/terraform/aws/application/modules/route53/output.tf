output "certificate_validation_arn" {
  value       = aws_acm_certificate_validation.frontend_certificate_validation.certificate_arn
  description = "The ARN of the validated ACM certificate"
}

output "route53_zone_id" {
  value       = data.aws_route53_zone.food_app_zone.zone_id
  description = "The ID of the Route53 hosted zone."
}
