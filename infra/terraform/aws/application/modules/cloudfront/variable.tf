variable "certificate_arn" {
  description = "The ARN of the ACM certificate"
  type        = string
}

variable "frontend_bucket_id" {
  description = "The ID of the S3 bucket"
  type        = string
}

variable "frontend_bucket_arn" {
  description = "The ARN of the S3 bucket"
  type        = string
}

variable "bucket_domain_name" {
  description = "The regional domain name of the S3 bucket"
  type        = string
}

variable "oai_cloudfront_access_identity_path" {
  description = "The CloudFront origin access identity path"
  type        = string
}

variable "oai_iam_arn" {
  description = "The ARN of the IAM associated with the CloudFront origin access identity"
  type        = string
}

