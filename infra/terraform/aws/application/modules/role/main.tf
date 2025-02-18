resource "aws_iam_role" "eks_cluster_role" {
  name               = "${var.project}-eks-cluster-role-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role.json

  tags = {
    Project     = var.project
    Environment = var.environment
    RoleType    = "EKS Cluster Role"
  }
}

resource "aws_iam_role_policy_attachment" "eks_policies" {
  for_each   = { for idx, policy_arn in var.eks_cluster_policy_arns : idx => policy_arn }
  policy_arn = each.value
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role" "node_group_role" {
  assume_role_policy = data.aws_iam_policy_document.node_assume_role_policy.json

  tags = {
    Project     = var.project
    Environment = var.environment
    RoleType    = "Node Group Role"
  }
}

resource "aws_iam_role_policy_attachment" "node_group_policies" {
  for_each   = { for idx, policy_arn in var.eks_cluster_node_policy_arns : idx => policy_arn }
  policy_arn = each.value
  role       = aws_iam_role.node_group_role.name
}

resource "aws_iam_role" "fargate_pod_execution_role" {
  name               = "${var.project}-fargate-pod-execution-role-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.fargate_pod_assume_role.json

  tags = {
    Project     = var.project
    Environment = var.environment
    RoleType    = "Fargate Pod Execution Role"
  }
}

resource "aws_iam_role_policy_attachment" "attach_fargate_policy" {
  policy_arn = var.fargate_pod_execution_role_policy_arn
  role       = aws_iam_role.fargate_pod_execution_role.name
}
