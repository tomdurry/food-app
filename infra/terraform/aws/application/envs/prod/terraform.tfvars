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
# iam setting
########################################
eks_cluster_policy_arns = [
  "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
  "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
]
fargate_pod_execution_role_policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"

########################################
# Lambda setting
########################################
lambda_key         = "mypackage.zip"
lambda_bucket_name = "lambda-zip-food-app-prod"
openai_api_key     = "sk-proj-xMOUvQHg1HcwnP9OZKJUT3BlbkFJqXbDGM2Gdr23UwDlqQK0"

########################################
# ECR setting
########################################
image_tag_mutability = "IMMUTABLE"
scan_on_push         = false

########################################
# EKS Cluster setting
########################################
cluster_name    = "food-app-cluster-prod"
cluster_version = "1.31"
