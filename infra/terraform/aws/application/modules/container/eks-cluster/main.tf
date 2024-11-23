resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.eks_role_arn
  vpc_config {
    subnet_ids = var.subnet_ids
  }
  version                   = var.cluster_version
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }
}

resource "aws_iam_role" "node_group_role" {
  assume_role_policy = data.aws_iam_policy_document.node_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "eks_worker_node" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_group_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cni" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_group_role.name
}

resource "aws_iam_role_policy_attachment" "ecr_readonly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_group_role.name
}


resource "aws_eks_node_group" "this_node_group" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-ec2-nodes"
  node_role_arn   = aws_iam_role.node_group_role.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.medium"]
  ami_type       = "AL2_x86_64"
}
