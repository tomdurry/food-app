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
# Providers
# ---------------------------------------------
provider "aws" {
  alias   = "default"
  profile = var.aws_profile != "" ? var.aws_profile : null
  region  = "ap-northeast-1"
}

provider "kubernetes" {
  host                   = module.eks-cluster.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks-cluster.cluster_ca_cert)
  exec {
    api_version = "client.authentication.k8s.io/v1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      var.cluster_name
    ]
  }
}

