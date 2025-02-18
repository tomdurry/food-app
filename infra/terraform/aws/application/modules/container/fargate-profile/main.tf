resource "aws_eks_fargate_profile" "this" {
  cluster_name           = var.cluster_name
  fargate_profile_name   = "food-app-fargate-profile"
  pod_execution_role_arn = var.pod_execution_role_arn

  subnet_ids = var.subnet_ids

  selector {
    namespace = var.environment
    labels = {
      app = "go-app"
    }
  }

  selector {
    namespace = "kube-system"
  }

  tags = {
    Project     = var.project
    Environment = var.environment
    Resource    = "Fargate Profile"
  }
}
