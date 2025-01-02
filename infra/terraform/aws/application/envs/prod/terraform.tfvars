########################################
# Environment setting
########################################
project     = "food-app"
environment = "prod"

########################################
# VPC setting
########################################
vpc_cidr             = "10.0.0.0/16"
enable_dns_support   = true
enable_dns_hostnames = true
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.3.0/24"]
private_subnet_cidrs = ["10.0.2.0/24", "10.0.4.0/24"]
availability_zones   = ["ap-northeast-1a", "ap-northeast-1c"]

service_endpoints = {
  api_gateway = "com.amazonaws.ap-northeast-1.execute-api"
  lambda      = "com.amazonaws.ap-northeast-1.lambda"
  ecr         = "com.amazonaws.ap-northeast-1.ecr.api"
  cloudwatch  = "com.amazonaws.ap-northeast-1.monitoring"
  rds         = "com.amazonaws.ap-northeast-1.rds"
  s3          = "com.amazonaws.ap-northeast-1.s3"
}

########################################
# Subnet and Route settings
########################################
public_subnet_count       = 2
private_subnet_count      = 2
nat_gateway_count         = 1
public_route_table_count  = 2
private_route_table_count = 2
map_public_ip_on_launch   = true
internet_route_cidr       = "0.0.0.0/0"

########################################
# Security Group settings
########################################
http_port           = 80
ingress_protocol    = "tcp"
ingress_cidr_blocks = ["0.0.0.0/0"]
egress_from_port    = 0
egress_to_port      = 0
egress_protocol     = "-1"
egress_cidr_blocks  = ["0.0.0.0/0"]


########################################
# role setting
########################################
eks_cluster_policy_arns = [
  "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
  "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
]
eks_cluster_node_policy_arns = [
  "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
  "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
  "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
]
fargate_pod_execution_role_policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"

########################################
# Lambda setting
########################################
lambda_bucket_name   = "food-app-generate-lambda-bucket"
lambda_key           = "mypackage.zip"
lambda_role_name     = "lambda-role"
lambda_function_name = "recipe_generate"
lambda_handler       = "recipe_generate.lambda_handler"
lambda_runtime       = "python3.12"
lambda_timeout       = 60
lambda_architectures = ["arm64"]
openai_api_key       = "sk-proj-xMOUvQHg1HcwnP9OZKJUT3BlbkFJqXbDGM2Gdr23UwDlqQK0"

########################################
# API Gateway setting
########################################
api_name               = "recipe-generate-api"
protocol_type          = "HTTP"
cors_allow_origins     = ["*"]
cors_allow_methods     = ["POST"]
cors_allow_headers     = ["Content-Type"]
cors_max_age           = 3600
integration_type       = "AWS_PROXY"
payload_format_version = "2.0"
route_key              = "POST /generate-recipe"
stage_name             = "$default"
auto_deploy            = true
statement_id           = "AllowApiGatewayInvoke"
lambda_action          = "lambda:InvokeFunction"
principal              = "apigateway.amazonaws.com"
ssm_parameter_name     = "/recipe-generate/api-url"
ssm_parameter_type     = "SecureString"


########################################
# ECR setting
########################################
image_tag_mutability = "IMMUTABLE"
scan_on_push         = false

########################################
# EKS Cluster setting
########################################
addon_name          = "amazon-cloudwatch-observability"
cluster_name        = "food-app-cluster-prod"
cluster_version     = "1.31"
authentication_mode = "API_AND_CONFIG_MAP"
bootstrap_cluster_creator_admin_permissions = true
desired_size        = 2
max_size            = 3
min_size            = 1
instance_types      = ["t3.medium"]
ami_type            = "AL2_x86_64"
force_delete        = true