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

