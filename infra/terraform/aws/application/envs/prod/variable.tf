########################################
# Environment variable
########################################
variable "aws_profile" {
  type    = string
  default = "default"
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
  description = "A list of IAM policy ARNs of eks_cluster_policy_arns"
  type        = list(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  ]
}

variable "eks_cluster_node_policy_arns" {
  description = "A list of IAM policy ARNs of eks_cluster_node_policy_arns"
  type        = list(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
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
  default     = "prod"
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
  default     = 60
}

variable "lambda_architectures" {
  description = "Architectures for the Lambda function"
  default     = ["x86_64"]
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
variable "addon_name" {
  description = "The name of the addon name"
  type        = string
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "The Kubernetes version for the EKS cluster"
  type        = string
}

variable "authentication_mode" {
  description = "The name of the authentication mode"
  type        = string
}

variable "bootstrap_cluster_creator_admin_permissions" {
  description = "The name of the bootstrap cluster creator admin permissions"
  type        = string
}

variable "desired_size" {
  description = "The desired number of nodes in the EKS node group"
  type        = number
}

variable "max_size" {
  description = "The maximum number of nodes in the EKS node group"
  type        = number
}

variable "min_size" {
  description = "The minimum number of nodes in the EKS node group"
  type        = number
}

variable "instance_types" {
  description = "List of EC2 instance types for the EKS node group"
  type        = list(string)
}

variable "ami_type" {
  description = "The force delete for the EKS node group"
  type        = string
}

variable "force_delete" {
  description = "The AMI type for the EKS node group"
  type        = string
}

########################################
# RDS  variable
########################################
variable "lambda_sg_from_port" {
  description = "The starting port for the Lambda security group."
  type        = number
}

variable "lambda_sg_to_port" {
  description = "The ending port for the Lambda security group."
  type        = number
}

variable "lambda_sg_protocol" {
  description = "The protocol for the Lambda security group."
  type        = string
}

variable "lambda_sg_cidr_blocks" {
  description = "The CIDR blocks allowed for the Lambda security group."
  type        = list(string)
}

variable "rds_sg_from_port" {
  description = "The starting port for the RDS security group."
  type        = number
}

variable "rds_sg_to_port" {
  description = "The ending port for the RDS security group."
  type        = number
}

variable "rds_sg_protocol" {
  description = "The protocol for the RDS security group."
  type        = string
}

variable "rds_sg_cidr_blocks" {
  description = "The CIDR blocks allowed for the RDS security group."
  type        = list(string)
}

variable "allocated_storage" {
  description = "The amount of storage allocated to the RDS instance in GB."
  type        = number
}

variable "engine" {
  description = "The database engine to use."
  type        = string
}

variable "engine_version" {
  description = "The version of the database engine."
  type        = string
}

variable "instance_class" {
  description = "The instance class for the RDS instance."
  type        = string
}

variable "parameter_group_name" {
  description = "The parameter group name for the RDS instance."
  type        = string
}

variable "skip_final_snapshot" {
  description = "Whether to skip the final snapshot on instance deletion."
  type        = bool
}

variable "publicly_accessible" {
  description = "Whether the RDS instance should be publicly accessible."
  type        = bool
}

variable "lambda_to_rds_type" {
  description = "Type of the connection between Lambda and RDS."
  type        = string
}

variable "lambda_to_rds_from_port" {
  description = "The starting port for the Lambda to RDS connection."
  type        = number
}

variable "lambda_to_rds_to_port" {
  description = "The ending port for the Lambda to RDS connection."
  type        = number
}

variable "lambda_to_rds_protocol" {
  description = "Protocol used for Lambda to RDS connection."
  type        = string
}

variable "eks_to_rds_rds_type" {
  description = "Type of the connection between EKS and RDS."
  type        = string
}

variable "eks_to_rds_from_port" {
  description = "The starting port for the EKS to RDS connection."
  type        = number
}

variable "eks_to_rds_to_port" {
  description = "The ending port for the EKS to RDS connection."
  type        = number
}

variable "eks_to_rds_protocol" {
  description = "Protocol used for EKS to RDS connection."
  type        = string
}

########################################
# Lambda Function variable
########################################
variable "region" {
  description = "The AWS region"
}

########################################
# S3 variable
########################################
variable "block_public_acls" {
  description = "Specifies whether Amazon S3 should block public ACLs for this bucket"
  type        = bool
}

variable "block_public_policy" {
  description = "Specifies whether Amazon S3 should block public bucket policies for this bucket"
  type        = bool
}

variable "ignore_public_acls" {
  description = "Specifies whether Amazon S3 should ignore public ACLs for this bucket"
  type        = bool
}

variable "restrict_public_buckets" {
  description = "Specifies whether Amazon S3 should restrict public bucket policies for this bucket"
  type        = bool
}

########################################
# Route53 variable
########################################
variable "ttl" {
  description = "Specifies the TTL (Time To Live) value for resources"
  type        = number
}

########################################
# Cloudfront variable
########################################
variable "origin_id" {
  description = "The origin ID of the distribution."
  type        = string
}

variable "enabled" {
  description = "Specifies whether the distribution is enabled."
  type        = bool
}

variable "default_root_object" {
  description = "The object that CloudFront serves when the root URL is requested."
  type        = string
}

variable "domain_name" {
  description = "The domain name for the CloudFront distribution and Route 53 record"
  type        = string
}

variable "allowed_methods" {
  description = "List of allowed HTTP methods for the distribution."
  type        = list(string)
}

variable "cached_methods" {
  description = "List of HTTP methods that will be cached."
  type        = list(string)
}

variable "target_origin_id" {
  description = "The target origin ID for the cache behavior."
  type        = string
}

variable "query_string" {
  description = "Specifies whether to forward query strings to the origin."
  type        = bool
}

variable "forward" {
  description = "Specifies the headers, cookies, or query strings to forward to the origin."
  type        = string
}

variable "viewer_protocol_policy" {
  description = "The protocol policy for the viewer."
  type        = string
}

variable "error_code" {
  description = "The HTTP error code for custom error responses."
  type        = number
}

variable "response_code" {
  description = "The HTTP response code to return for custom error responses."
  type        = number
}

variable "response_page_path" {
  description = "The path to the custom error response page."
  type        = string
}

variable "ssl_support_method" {
  description = "Specifies the SSL/TLS support method."
  type        = string
}

variable "minimum_protocol_version" {
  description = "The minimum SSL/TLS protocol version that CloudFront can use."
  type        = string
}

variable "restriction_type" {
  description = "The restriction type for geographic restrictions."
  type        = string
}

variable "type" {
  description = "The type of cache behavior."
  type        = string
}

variable "evaluate_target_health" {
  description = "Indicates whether to evaluate the target health of an origin."
  type        = bool
}
