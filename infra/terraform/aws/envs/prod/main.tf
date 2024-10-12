module "iam" {
  source = "../../modules/iam"
}

module "network" {
  source = "../../modules/network"
}

module "pipeline" {
  source                   = "../../modules/pipeline"
  branch_name              = var.branch_name
  codestar_connection_name = var.codestar_connection_name
  environment              = var.environment
  repository_name          = var.repository_name
  buildspec_file_path      = var.buildspec_file_path
  codebuild_image          = var.codebuild_image
  project_name             = var.project
  artifact_bucket_name     = var.artifact_bucket_name
}

module "recipeApi" {
  source             = "../../modules/recipeApi"
  environment        = var.environment
  project            = var.project
  lambda_key         = var.lambda_key
  lambda_bucket_name = var.lambda_bucket_name
  openai_api_key     = var.openai_api_key
}

