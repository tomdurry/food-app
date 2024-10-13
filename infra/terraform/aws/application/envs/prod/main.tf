module "network" {
  source = "../../modules/network"
}

module "recipeApi" {
  source             = "../../modules/recipeApi"
  environment        = var.environment
  project            = var.project
  lambda_key         = var.lambda_key
  lambda_bucket_name = var.lambda_bucket_name
  openai_api_key     = var.openai_api_key
}

