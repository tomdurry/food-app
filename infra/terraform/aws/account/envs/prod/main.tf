module "iam" {
  source                                = "../../modules/iam"
  administrator_user_name               = var.administrator_user_name
  administrator_role_name               = var.administrator_role_name
  watcher_user_name                     = var.watcher_user_name
  watcher_role_name                     = var.watcher_role_name
  administrator_assume_role_policy_name = var.administrator_assume_role_policy_name
  watcher_assume_role_policy_name       = var.watcher_assume_role_policy_name
  mfa_policy_name                       = var.mfa_policy_name
  administrator_policy_arn              = var.administrator_policy_arn
  watcher_policy_arn                    = var.watcher_policy_arn
}
