########################################
# Environment setting
########################################
project     = "food-app"
environment = "prod"

########################################
# Pipeline setting
########################################
iam_role_name             = "CodeBuildRole"
admin_policy_arn          = "arn:aws:iam::aws:policy/AdministratorAccess"
source_type               = "CODEPIPELINE"
buildspec_file_path       = "infra/terraform/aws/pipeline/buildspec/buildspec-terraform-deploy.yml"
codebuild_image           = "hashicorp/terraform:latest"
compute_type              = "BUILD_GENERAL1_SMALL"
environment_type          = "LINUX_CONTAINER"
environment_variable_name = "ENV"
artifact_type             = "CODEPIPELINE"
artifact_bucket_name      = "food-app-artifact-bucket"
force_destroy             = true
codestar_connection_name  = "GitHubConnection"
provider_type             = "GitHub"
pipeline_suffix           = "pipeline"
artifact_store_type       = "S3"
source_stage_name         = "Source"
source_action_name        = "SourceAction"
source_category           = "Source"
source_owner              = "AWS"
source_provider           = "CodeStarSourceConnection"
source_version            = "1"
source_output_artifacts   = ["SourceArtifact"]
repository_name           = "tomdurry/food-app"
branch_name               = "main"
build_stage_name          = "Build"
build_action_name         = "BuildAction"
build_category            = "Build"
build_owner               = "AWS"
build_provider            = "CodeBuild"
build_version             = "1"
build_input_artifacts     = ["SourceArtifact"]
build_output_artifacts    = ["BuildArtifact"]
