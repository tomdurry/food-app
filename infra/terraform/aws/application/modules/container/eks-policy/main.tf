resource "aws_eks_access_entry" "eks-admin_role" {
  cluster_name  = "food-app-cluster-prod"
  principal_arn = data.aws_iam_role.admin_role.arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "eks-admin-policy" {
  cluster_name  = "food-app-cluster-prod"
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
  principal_arn = data.aws_iam_role.admin_role.arn

  access_scope {
    type = "cluster"
  }
}

resource "aws_eks_access_policy_association" "eks-cluster-admin-policy" {
  cluster_name  = "food-app-cluster-prod"
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = data.aws_iam_role.admin_role.arn

  access_scope {
    type = "cluster"
  }
}
