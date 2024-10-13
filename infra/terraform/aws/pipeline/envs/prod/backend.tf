terraform {
  backend "s3" {
    bucket         = "terraform-food-app-pipeline-s3-backend-prod"
    key            = "prod/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "terraform-food-app-pipeline-s3-backend-prod"
  }
}
