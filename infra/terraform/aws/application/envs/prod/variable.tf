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

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "The availability zones to use"
  type        = list(string)
}

variable "service_endpoints" {
  description = "List of service names for VPC endpoints"
  type        = map(string)
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
