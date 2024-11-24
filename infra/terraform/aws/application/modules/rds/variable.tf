variable "environment" {
  type    = string
  default = "prod"
}

variable "vpc_id" {
  description = "The ID of the VPC where the EKS cluster will be deployed."
  type        = string
}

variable "subnet_ids" {
  description = "List of subnets"
  type        = list(string)
}

variable "eks_cluster_sg_id" {
  description = "The Security Group ID of the EKS cluster."
  type        = string
}
