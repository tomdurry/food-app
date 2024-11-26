variable "cloudfront_oai" {
  description = "CloudFront Origin Access Identity"
  type        = string
}

variable "certificate_arn" {
  description = "The ARN of the ACM certificate"
  type        = string
}

variable "frontend_bucket_id" {
  description = "The ID of the S3 bucket"
  type        = string
}

variable "bucket_domain_name" {
  description = "The regional domain name of the S3 bucket"
  type        = string
}
