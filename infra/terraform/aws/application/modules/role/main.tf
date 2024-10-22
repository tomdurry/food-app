resource "aws_iam_role" "eks_cluster_role" {
  name               = "${var.project}-eks-cluster-role-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role.json
}

resource "aws_iam_role_policy_attachment" "eks_policies" {
  for_each   = { for idx, policy_arn in var.eks_cluster_policy_arns : idx => policy_arn }
  policy_arn = each.value
  role       = aws_iam_role.eks_cluster_role.name
}


resource "aws_iam_role" "fargate_pod_execution_role" {
  name               = "${var.project}-fargate-pod-execution-role-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.fargate_pod_assume_role.json
}

resource "aws_iam_role_policy_attachment" "attach_fargate_policy" {
  policy_arn = var.fargate_pod_execution_role_policy_arn
  role       = aws_iam_role.fargate_pod_execution_role.name
}
