resource "aws_acm_certificate" "acm_certificate" {
  provider          = aws.us_east_1
  domain_name       = "food-app-generation.com"
  validation_method = "DNS"

  tags = {
    Environment = "prod"
  }
}

resource "aws_ssm_parameter" "certificate_arn" {
  name  = "/${var.environment}/acm_certificate_arn"
  type  = "String"
  value = aws_acm_certificate.acm_certificate.arn

  tags = {
    Environment = "prod"
  }
}
