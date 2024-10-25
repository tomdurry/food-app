########################################
# Account variable
########################################
variable "administrator_user_name" {
  description = "The name of the Administrator user"
  type        = string
  default     = "Administrator"
}

variable "administrator_role_name" {
  description = "The name of the Administrator role"
  type        = string
  default     = "AdministratorRole"
}

variable "administrator_assume_role_policy_name" {
  description = "The name of the policy allowing assume role for Administrator"
  type        = string
  default     = "AdministratorAssumeRolePolicy"
}

variable "administrator_policy_arn" {
  description = "The ARN of the policy to attach to the Administrator role"
  type        = string
  default     = "arn:aws:iam::aws:policy/AdministratorAccess"
}

variable "watcher_user_name" {
  description = "The name of the Watcher user"
  type        = string
  default     = "Watcher"
}

variable "watcher_role_name" {
  description = "The name of the Watcher role"
  type        = string
  default     = "WatcherRole"
}

variable "watcher_assume_role_policy_name" {
  description = "The name of the policy allowing assume role for Watcher"
  type        = string
  default     = "WatcherAssumeRolePolicy"
}

variable "watcher_policy_arn" {
  description = "The ARN of the policy to attach to the Watcher role"
  type        = string
  default     = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

variable "mfa_policy_name" {
  description = "The name of the MFA setup policy"
  type        = string
  default     = "MFASetupPolicy"
}
