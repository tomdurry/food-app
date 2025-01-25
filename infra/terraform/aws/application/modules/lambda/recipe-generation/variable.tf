variable "project" {
  type    = string
  default = "food-app"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "region" {
  description = "The AWS region"
  default     = "ap-northeast-1"
}

variable "lambda_bucket_name" {
  description = "Name of the S3 bucket for Lambda functions"
  type        = string
}

variable "lambda_role_name" {
  description = "Name of the IAM role for the Lambda function"
  default     = "lambda-role"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  default     = "recipe-generate"
}

variable "lambda_handler" {
  description = "Handler for the Lambda function"
  default     = "recipe_generate.lambda_handler"
}

variable "lambda_runtime" {
  description = "Runtime for the Lambda function"
  default     = "python3.12"
}

variable "lambda_timeout" {
  description = "Timeout for the Lambda function in seconds"
  default     = 180
}

variable "lambda_architectures" {
  description = "Architectures for the Lambda function"
  default     = ["x86_64"]
}
