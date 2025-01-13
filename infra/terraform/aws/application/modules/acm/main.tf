resource "aws_acm_certificate" "cloudfront_certificate" {
  provider          = aws.us_east_1
  domain_name       = "food-app-generation.com"
  validation_method = "DNS"

  tags = {
    Project     = var.project
    Environment = var.environment
  }
}

resource "aws_acm_certificate" "lb_certificate" {
  domain_name       = "api.food-app-generation.com"
  validation_method = "DNS"

  tags = {
    Project     = var.project
    Environment = var.environment
  }
}

resource "aws_ssm_parameter" "lb_certificate_arn" {
  name  = "/${var.environment}/lb_certificate_arn"
  type  = "String"
  value = aws_acm_certificate.lb_certificate.arn

  tags = {
    Project     = var.project
    Environment = var.environment
  }
}
