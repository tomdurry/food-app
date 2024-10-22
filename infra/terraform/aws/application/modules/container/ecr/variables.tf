variable "project" {
  type    = string
  default = "food-app"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "image_tag_mutability" {
  description = "The mutability setting for image tags in the repository"
  type        = string
  default     = "MUTABLE"
}

variable "scan_on_push" {
  description = "Enable or disable image scanning on push"
  type        = bool
  default     = true
}
