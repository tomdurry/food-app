resource "aws_eks_access_entry" "example" {
  cluster_name  = "food-app-cluster-prod"
  principal_arn = data.aws_iam_role.admin_role.arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "example" {
  cluster_name  = "food-app-cluster-prod"
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
  principal_arn = data.aws_iam_role.admin_role.arn

  access_scope {
    type = "cluster"
  }
}
