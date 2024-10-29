resource "aws_eks_fargate_profile" "this" {
  cluster_name           = var.cluster_name
  fargate_profile_name   = "food-app-fargate-profile"
  pod_execution_role_arn = var.pod_execution_role_arn

  subnet_ids = var.subnet_ids

  selector {
    namespace = "${var.project}-${var.environment}"
    labels = {
      app = "food-app"
    }
  }
}
