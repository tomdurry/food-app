variable "branch_name" {
  description = "The branch name in the repository"
  type        = string
}

variable "codestar_connection_name" {
  description = "The name of the CodeStar connection"
  type        = string
}

variable "environment" {
  description = "The environment (e.g., dev, prod)"
  type        = string
}

variable "repository_name" {
  description = "The full repository name (e.g., username/repo)"
  type        = string
}

variable "buildspec_file_path" {
  description = "The path to the buildspec file"
  type        = string
}

variable "codebuild_image" {
  description = "The image to be used for CodeBuild"
  type        = string
}

variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "artifact_bucket_name" {
  description = "The name of the S3 bucket for artifacts"
  type        = string
}
