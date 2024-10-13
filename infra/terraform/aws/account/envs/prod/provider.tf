# ---------------------------------------------
# Terraform configuration
# ---------------------------------------------
terraform {
  required_version = ">= 1.9.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.67"
    }
  }
}


# ---------------------------------------------
# Provider
# ---------------------------------------------
provider "aws" {
  profile = var.aws_profile != "" ? var.aws_profile : null
  region  = "ap-northeast-1"
}
