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
