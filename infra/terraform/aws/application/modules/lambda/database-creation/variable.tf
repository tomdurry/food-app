variable "project" {
  type    = string
  default = "food-app"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "region" {
  description = "The AWS region"
  default     = "ap-northeast-1"
}

variable "db_username" {
  description = "Database username"
  default     = "yukihiro"
}

variable "db_password" {
  description = "Database password"
  default     = "Yuki3769"
}

variable "subnet_ids" {
  description = "List of subnets"
  type        = list(string)
}

variable "lambda_sg_id" {
  description = "The ID of the Lambda security group."
  type        = string
}
