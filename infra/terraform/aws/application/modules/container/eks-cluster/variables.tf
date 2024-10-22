variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the EKS cluster will be deployed."
  type        = string
}

variable "eks_role_arn" {
  description = "The ARN of the IAM role for the EKS cluster."
  type        = string
}

variable "subnet_ids" {
  description = "List of subnets"
  type        = list(string)
}
