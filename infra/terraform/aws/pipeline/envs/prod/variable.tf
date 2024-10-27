########################################
# Environment variable
########################################
variable "aws_profile" {
  type    = string
  default = "terraform"
}

variable "project" {
  type    = string
  default = "food-app"
}

variable "environment" {
  type    = string
  default = "prod"
}

########################################
# Pipeline variable
########################################

variable "iam_role_name" {
  description = "The name of the IAM role for CodeBuild"
  type        = string
}

variable "admin_policy_arn" {
  description = "The ARN of the AdministratorAccess policy"
  type        = string
}

variable "source_type" {
  description = "The source type for the CodeBuild project (e.g., CODEPIPELINE, GITHUB)"
  type        = string
  default     = "CODEPIPELINE"
}

variable "buildspec_file_path" {
  description = "The path to the buildspec file"
  type        = string
}

variable "codebuild_image" {
  description = "The image to be used for CodeBuild"
  type        = string
}

variable "compute_type" {
  description = "The compute type for the CodeBuild environment"
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
}

variable "environment_type" {
  description = "The type of the environment (e.g., LINUX_CONTAINER)"
  type        = string
  default     = "LINUX_CONTAINER"
}

variable "environment_variable_name" {
  description = "The name of the environment variable for CodeBuild"
  type        = string
  default     = "ENV"
}

variable "artifact_type" {
  description = "The type of artifacts for CodeBuild"
  type        = string
  default     = "CODEPIPELINE"
}

variable "artifact_bucket_name" {
  description = "The name of the S3 bucket for artifacts"
  type        = string
}

variable "force_destroy" {
  description = "Whether to force destroy the S3 bucket"
  type        = bool
  default     = true
}

variable "codestar_connection_name" {
  description = "The name of the CodeStar connection"
  type        = string
}

variable "provider_type" {
  description = "The provider type for CodeStar connection"
  type        = string
  default     = "GitHub"
}

variable "pipeline_suffix" {
  description = "Suffix for the CodePipeline name"
  type        = string
  default     = "pipeline"
}

variable "artifact_store_type" {
  description = "The type of artifact store for CodePipeline"
  type        = string
  default     = "S3"
}

variable "source_stage_name" {
  description = "The name of the source stage"
  type        = string
  default     = "Source"
}

variable "source_action_name" {
  description = "The name of the source action"
  type        = string
  default     = "SourceAction"
}

variable "source_category" {
  description = "The category of the source action"
  type        = string
  default     = "Source"
}

variable "source_owner" {
  description = "The owner of the source action"
  type        = string
  default     = "AWS"
}

variable "source_provider" {
  description = "The provider for the source action"
  type        = string
  default     = "CodeStarSourceConnection"
}

variable "source_version" {
  description = "The version for the source action"
  type        = string
  default     = "1"
}

variable "source_output_artifacts" {
  description = "The output artifacts for the source action"
  type        = list(string)
  default     = ["source_output"]
}

variable "repository_name" {
  description = "The full repository name (e.g., username/repo)"
  type        = string
}

variable "branch_name" {
  description = "The branch name in the repository"
  type        = string
}

variable "build_stage_name" {
  description = "The name of the build stage"
  type        = string
  default     = "Build"
}

variable "build_action_name" {
  description = "The name of the build action"
  type        = string
  default     = "BuildAction"
}

variable "build_category" {
  description = "The category of the build action"
  type        = string
  default     = "Build"
}

variable "build_owner" {
  description = "The owner of the build action"
  type        = string
  default     = "AWS"
}

variable "build_provider" {
  description = "The provider for the build action"
  type        = string
  default     = "CodeBuild"
}

variable "build_version" {
  description = "The version for the build action"
  type        = string
  default     = "1"
}

variable "build_input_artifacts" {
  description = "The input artifacts for the build action"
  type        = list(string)
  default     = ["source_output"]
}

variable "build_output_artifacts" {
  description = "The output artifacts for the build action"
  type        = list(string)
  default     = ["SourceArtifact"]
}
