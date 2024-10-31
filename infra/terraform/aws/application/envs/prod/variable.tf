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
# VPC  variable
########################################

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "enable_dns_support" {
  description = "Enable DNS support for the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames for the VPC"
  type        = bool
  default     = true
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

variable "public_subnet_count" {
  description = "Number of public subnets"
  type        = number
  default     = 2
}

variable "private_subnet_count" {
  description = "Number of private subnets"
  type        = number
  default     = 2
}

variable "nat_gateway_count" {
  description = "The number of NAT Gateways to create for the VPC."
  type        = number
  default     = 1
}

variable "public_route_table_count" {
  description = "Number of public route tables"
  type        = number
  default     = 2
}

variable "private_route_table_count" {
  description = "Number of private route tables"
  type        = number
  default     = 2
}

variable "map_public_ip_on_launch" {
  description = "Map public IP on launch for public subnets"
  type        = bool
  default     = true
}

variable "internet_route_cidr" {
  description = "CIDR block for the internet route"
  type        = string
  default     = "0.0.0.0/0"
}

variable "service_endpoints" {
  description = "List of service names for VPC endpoints"
  type        = map(string)
}

variable "http_port" {
  description = "Port for HTTP ingress"
  type        = number
  default     = 80
}

variable "ingress_protocol" {
  description = "Protocol for HTTP ingress"
  type        = string
  default     = "tcp"
}

variable "ingress_cidr_blocks" {
  description = "CIDR blocks for ingress traffic"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "egress_from_port" {
  description = "From port for egress traffic"
  type        = number
  default     = 0
}

variable "egress_to_port" {
  description = "To port for egress traffic"
  type        = number
  default     = 0
}

variable "egress_protocol" {
  description = "Protocol for egress traffic"
  type        = string
  default     = "-1"
}

variable "egress_cidr_blocks" {
  description = "CIDR blocks for egress traffic"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

########################################
# role  variable
########################################

variable "eks_cluster_policy_arns" {
  description = "A list of IAM policy ARNs to attach to the role."
  type        = list(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  ]
}

variable "fargate_pod_execution_role_policy_arn" {
  description = "The ARN of the policy to attach to the Fargate pod execution role"
  type        = string
  default     = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
}

########################################
# Api Gateway  variable
########################################
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


########################################
# Lambda  variable
########################################
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

########################################
# ECR  variable
########################################
variable "image_tag_mutability" {
  description = "The mutability setting for image tags in the repository"
  type        = string
  default     = "MUTABLE"
}

variable "scan_on_push" {
  description = "Enable or disable image scanning on push"
  type        = bool
  default     = true
}

########################################
# EKS  variable
########################################
variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "The Kubernetes version for the EKS cluster"
  type        = string
}
