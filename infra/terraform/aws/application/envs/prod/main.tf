module "network" {
  source               = "../../modules/network"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  service_endpoints    = var.service_endpoints
}

module "recipeApi" {
  source             = "../../modules/recipeApi"
  environment        = var.environment
  project            = var.project
  lambda_key         = var.lambda_key
  lambda_bucket_name = var.lambda_bucket_name
  openai_api_key     = var.openai_api_key
}

