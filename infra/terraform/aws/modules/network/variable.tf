variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  description = "The availability zones to use"
  type        = list(string)
  default     = ["ap-northeast-1a", "ap-northeast-1c"]
}

variable "service_endpoints" {
  description = "List of service names for VPC endpoints"
  type        = map(string)
  default = {
    api_gateway = "com.amazonaws.ap-northeast-1.execute-api"
    lambda      = "com.amazonaws.ap-northeast-1.lambda"
    ecr         = "com.amazonaws.ap-northeast-1.ecr.api"
    cloudwatch  = "com.amazonaws.ap-northeast-1.monitoring"
    rds         = "com.amazonaws.ap-northeast-1.rds"
    s3          = "com.amazonaws.ap-northeast-1.s3"
  }
}
