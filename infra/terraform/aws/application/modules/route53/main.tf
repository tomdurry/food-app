resource "aws_route53_zone" "example_zone" {
  name = "food-app-generation.com"
  tags = {
    Environment = "prod"
  }
}

resource "aws_route53_record" "frontend_alias" {
  zone_id = aws_route53_zone.example_zone.zone_id
  name    = "food-app-generation.com"
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}
