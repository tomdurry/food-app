# ---------------------------------------------
# Variables
# ---------------------------------------------
variable "aws_profile" {
  type    = string
  default = "terraform"
}

variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "branch_name" {
  description = "Branch name for the pipeline source"
  type        = string
}

variable "codestar_connection_name" {
  description = "CodeStar connection name for GitHub"
  type        = string
}

variable "repository_name" {
  description = "The GitHub repository to use for the pipeline"
  type        = string
}

variable "buildspec_file_path" {
  description = "Path to the buildspec file"
  type        = string
}

variable "codebuild_image" {
  description = "Docker image to use for CodeBuild"
  type        = string
}

variable "artifact_bucket_name" {
  description = "S3 bucket to store build artifacts"
  type        = string
}

variable "lambda_key" {
  description = "The S3 key for the Lambda function ZIP file"
  type        = string
}

variable "lambda_bucket_name" {
  description = "The name of the S3 bucket where the Lambda ZIP file is stored"
  type        = string
}

variable "openai_api_key" {
  description = "The OpenAI API key for accessing the API"
  type        = string
  sensitive   = true
}
