variable "project" {
  type    = string
  default = "food-app"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "addon_name" {
  description = "Name of the addon_name"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version of the EKS cluster"
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

variable "vpc_id" {
  description = "The ID of the VPC where the EKS cluster will be deployed."
  type        = string
}

variable "eks_role_arn" {
  description = "The ARN of the IAM role for the EKS cluster."
  type        = string
}

variable "node_group_role_arn" {
  description = "The ARN of the IAM role for the EKS cluster."
  type        = string
}

variable "subnet_ids" {
  description = "List of subnets"
  type        = list(string)
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
  description = "The AMI type for the EKS node group"
  type        = string
}
