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
buildspec_file_path      = "infra/terraform/aws/buildspec/buildspec.yml"
codebuild_image          = "hashicorp/terraform:latest"
artifact_bucket_name     = "food-app-artifact-bucket"

########################################
# Lambda setting
########################################
lambda_key         = "mypackage.zip"
lambda_bucket_name = "lambda-zip-food-app-prod"
openai_api_key     = "sk-proj-xMOUvQHg1HcwnP9OZKJUT3BlbkFJqXbDGM2Gdr23UwDlqQK0"
