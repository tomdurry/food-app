########################################
# Environment setting
########################################
project     = "food-app"
environment = "prod"

########################################
# Pipeling setting
########################################
branch_name              = "main"
codestar_connection_name = "GitHubConnection"
repository_name          = "tomdurry/food-app"
buildspec_file_path      = "infra/terraform/aws/pipeline/buildspec/buildspec.yml"
codebuild_image          = "hashicorp/terraform:latest"
artifact_bucket_name     = "food-app-artifact-bucket"
