# /modules/kubernetes-app/providers.tf
provider "kubernetes" {
  config_path = "~/.kube/config"
}
