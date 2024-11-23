output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_ca_cert" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

output "cluster_security_group_id" {
  value = aws_eks_cluster.this.resources_vpc_config[0].cluster_security_group_id
}
