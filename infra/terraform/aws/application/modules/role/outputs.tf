output "eks_cluster_role_arn" {
  description = "The ARN of the EKS cluster role"
  value       = aws_iam_role.eks_cluster_role.arn
}

output "node_group_role_arn" {
  description = "The ARN of the Node group role"
  value       = aws_iam_role.node_group_role.arn
}


output "fargate_pod_execution_role_arn" {
  description = "The ARN of the Fargate pod execution role"
  value       = aws_iam_role.fargate_pod_execution_role.arn
}
