variable "environment" {
  type    = string
  default = "prod"
}

variable "api_name" {
  description = "The name of the API Gateway"
  default     = "recipe-generate-api"
}

variable "protocol_type" {
  description = "The protocol type for the API Gateway"
  default     = "HTTP"
}

variable "cors_allow_origins" {
  description = "List of origins allowed for CORS"
  default     = ["*"]
}

variable "cors_allow_methods" {
  description = "List of HTTP methods allowed for CORS"
  default     = ["POST"]
}

variable "cors_allow_headers" {
  description = "List of headers allowed for CORS"
  default     = ["Content-Type"]
}

variable "cors_max_age" {
  description = "Max age for CORS preflight requests"
  default     = 3600
}

variable "integration_type" {
  description = "The type of integration for API Gateway"
  default     = "AWS_PROXY"
}

variable "integration_uri" {
  description = "The URI for the API Gateway integration"
  type        = string
}

variable "payload_format_version" {
  description = "The payload format version for the integration"
  default     = "2.0"
}

variable "route_key" {
  description = "The route key for the API Gateway route"
  default     = "POST /generate-recipe"
}

variable "stage_name" {
  description = "The name of the API Gateway stage"
  default     = "$default"
}

variable "auto_deploy" {
  description = "Whether the stage should auto-deploy"
  default     = true
}

variable "statement_id" {
  description = "The statement ID for the Lambda permission"
  default     = "AllowApiGatewayInvoke"
}

variable "lambda_action" {
  description = "The action for the Lambda permission"
  default     = "lambda:InvokeFunction"
}

variable "function_name" {
  description = "The name of the Lambda function for the API Gateway permission"
  type        = string
}

variable "principal" {
  description = "The principal for the Lambda permission"
  default     = "apigateway.amazonaws.com"
}

variable "ssm_parameter_name" {
  description = "The name of the SSM parameter to store the API URL"
  default     = "/recipe-generate/api-url"
}

variable "ssm_parameter_type" {
  description = "The type of the SSM parameter"
  default     = "SecureString"
}
