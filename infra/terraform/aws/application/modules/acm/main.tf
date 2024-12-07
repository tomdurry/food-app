resource "aws_acm_certificate" "frontend_certificate" {
  provider          = aws.us_east_1
  domain_name       = "food-app-generation.com"
  validation_method = "DNS"

  tags = {
    Environment = "prod"
  }
}

