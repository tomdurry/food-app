terraform {
  backend "s3" {
    bucket         = "terraform-food-app-s3-bucket"
    key            = "dev/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "terraform-locks"
  }
}
