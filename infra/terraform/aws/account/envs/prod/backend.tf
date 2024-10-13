terraform {
  backend "s3" {
    bucket         = "terraform-food-app-account-s3-backend-prod"
    key            = "prod/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "terraform-food-app-account-s3-backend-prod"
  }
}
