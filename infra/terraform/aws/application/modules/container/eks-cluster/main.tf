resource "aws_eks_addon" "cloudwatch-observability" {
  addon_name   = var.addon_name
  cluster_name = aws_eks_cluster.this.name

  tags = {
    Project     = var.project
    Environment = var.environment
    Resource    = "EKS Addon"
  }
}

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.eks_role_arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  version                   = var.cluster_version
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  access_config {
    authentication_mode                         = var.authentication_mode
    bootstrap_cluster_creator_admin_permissions = var.bootstrap_cluster_creator_admin_permissions
  }

  tags = {
    Project     = var.project
    Environment = var.environment
    Resource    = "EKS Cluster"
  }
}

resource "aws_eks_node_group" "this_node_group" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-ec2-nodes"
  node_role_arn   = var.node_group_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  instance_types = var.instance_types
  ami_type       = var.ami_type

  tags = {
    Project     = var.project
    Environment = var.environment
    Resource    = "EKS Node Group"
  }
}
