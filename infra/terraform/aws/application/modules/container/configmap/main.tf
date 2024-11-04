resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = <<YAML
- rolearn: arn:aws:iam::039725305879:role/AdministratorRole
  username: admin
  groups:
    - system:masters
YAML
  }
}
