variable "project" {
  type    = string
  default = "food-app"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "eks_cluster_policy_arns" {
  description = "A list of IAM policy ARNs to attach to the role."
  type        = list(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  ]
}

variable "fargate_pod_execution_role_policy_arn" {
  description = "The ARN of the policy to attach to the Fargate pod execution role"
  type        = string
  default     = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
}
