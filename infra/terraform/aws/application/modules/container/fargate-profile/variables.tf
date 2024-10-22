variable "project" {
  type    = string
  default = "food-app"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "pod_execution_role_arn" {
  description = "The ARN of the Fargate pod execution role to be used by the Fargate profile"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnets"
  type        = list(string)
}
