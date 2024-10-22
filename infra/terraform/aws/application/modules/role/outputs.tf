output "eks_cluster_role_name" {
  description = "The name of the EKS cluster role"
  value       = aws_iam_role.eks_cluster_role.name
}

output "eks_cluster_role_arn" {
  description = "The ARN of the EKS cluster role"
  value       = aws_iam_role.eks_cluster_role.arn
}

output "fargate_pod_execution_role_name" {
  description = "The name of the Fargate pod execution role"
  value       = aws_iam_role.fargate_pod_execution_role.name
}

output "fargate_pod_execution_role_arn" {
  description = "The ARN of the Fargate pod execution role"
  value       = aws_iam_role.fargate_pod_execution_role.arn
}
