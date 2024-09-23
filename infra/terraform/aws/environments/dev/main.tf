module "account" {
  source = "../../modules/account"
}

module "pipeline" {
  source = "../../modules/pipeline"
}

module "recipeGeneration" {
  source      = "../../modules/recipeGeneration"
  environment = "dev"
  project     = "food-app"
}
