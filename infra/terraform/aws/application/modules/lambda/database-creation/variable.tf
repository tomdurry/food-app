variable "environment" {
  type    = string
  default = "prod"
}

variable "subnet_ids" {
  description = "List of subnets"
  type        = list(string)
}

variable "lambda_sg_id" {
  description = "The ID of the Lambda security group."
  type        = string
}
