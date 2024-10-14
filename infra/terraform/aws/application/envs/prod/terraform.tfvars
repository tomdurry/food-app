########################################
# Environment setting
########################################
project     = "food-app"
environment = "prod"

########################################
# VPC setting
########################################
vpc_cidr             = "10.0.0.0/16"
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
# Lambda setting
########################################
lambda_key         = "mypackage.zip"
lambda_bucket_name = "lambda-zip-food-app-prod"
openai_api_key     = "sk-proj-xMOUvQHg1HcwnP9OZKJUT3BlbkFJqXbDGM2Gdr23UwDlqQK0"
