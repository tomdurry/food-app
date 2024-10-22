variable "lambda_key" {
  description = "Key of the Lambda function zip file in the S3 bucket"
  type        = string
}

variable "lambda_bucket_name" {
  description = "Name of the S3 bucket for Lambda functions"
  type        = string
}

variable "openai_api_key" {
  description = "API key for OpenAI"
  type        = string
  sensitive   = true
}
