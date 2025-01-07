variable "project" {
  type    = string
  default = "food-app"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "block_public_acls" {
  description = "Specifies whether Amazon S3 should block public ACLs for this bucket"
  type        = bool
}

variable "block_public_policy" {
  description = "Specifies whether Amazon S3 should block public bucket policies for this bucket"
  type        = bool
}

variable "ignore_public_acls" {
  description = "Specifies whether Amazon S3 should ignore public ACLs for this bucket"
  type        = bool
}

variable "restrict_public_buckets" {
  description = "Specifies whether Amazon S3 should restrict public bucket policies for this bucket"
  type        = bool
}

variable "oai_iam_arn" {
  description = "The ARN of the IAM associated with the CloudFront origin access identity"
  type        = string
}
