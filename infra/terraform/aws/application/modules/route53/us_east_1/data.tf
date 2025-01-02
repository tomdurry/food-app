data "aws_route53_zone" "food_app_zone" {
  name         = "food-app-generation.com"
  private_zone = false
}
