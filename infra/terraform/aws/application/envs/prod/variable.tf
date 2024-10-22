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
# Lambda  variable
########################################
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
