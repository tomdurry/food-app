resource "aws_acm_certificate" "frontend_certificate" {
  domain_name       = "food-app-generation.com"
  validation_method = "DNS"

  tags = {
    Environment = "prod"
  }
}
