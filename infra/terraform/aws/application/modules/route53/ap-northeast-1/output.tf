output "route53_zone_id" {
  value       = data.aws_route53_zone.food_app_zone.zone_id
  description = "The ID of the Route53 hosted zone."
}
