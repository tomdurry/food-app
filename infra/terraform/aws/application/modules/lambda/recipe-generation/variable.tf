variable "lambda_bucket_name" {
  description = "Name of the S3 bucket for Lambda functions"
  type        = string
}

variable "lambda_key" {
  description = "Key of the Lambda function zip file in the S3 bucket"
  type        = string
}

variable "lambda_role_name" {
  description = "Name of the IAM role for the Lambda function"
  default     = "lambda-role"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  default     = "recipe_generate"
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
  default     = 60
}

variable "lambda_architectures" {
  description = "Architectures for the Lambda function"
  default     = ["arm64"]
}

variable "openai_api_key" {
  description = "API key for OpenAI"
  type        = string
  sensitive   = true
}
