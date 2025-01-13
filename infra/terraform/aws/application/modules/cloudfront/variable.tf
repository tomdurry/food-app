variable "project" {
  type    = string
  default = "food-app"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "origin_id" {
  description = "The origin ID of the distribution."
  type        = string
}

variable "enabled" {
  description = "Specifies whether the distribution is enabled."
  type        = bool
}

variable "default_root_object" {
  description = "The object that CloudFront serves when the root URL is requested."
  type        = string
}

variable "domain_name" {
  description = "The domain name for the CloudFront distribution and Route 53 record"
  type        = string
}

variable "allowed_methods" {
  description = "List of allowed HTTP methods for the distribution."
  type        = list(string)
}

variable "cached_methods" {
  description = "List of HTTP methods that will be cached."
  type        = list(string)
}

variable "target_origin_id" {
  description = "The target origin ID for the cache behavior."
  type        = string
}

variable "query_string" {
  description = "Specifies whether to forward query strings to the origin."
  type        = bool
}

variable "forward" {
  description = "Specifies the headers, cookies, or query strings to forward to the origin."
  type        = string
}

variable "viewer_protocol_policy" {
  description = "The protocol policy for the viewer."
  type        = string
}

variable "error_code" {
  description = "The HTTP error code for custom error responses."
  type        = number
}

variable "response_code" {
  description = "The HTTP response code to return for custom error responses."
  type        = number
}

variable "response_page_path" {
  description = "The path to the custom error response page."
  type        = string
}

variable "ssl_support_method" {
  description = "Specifies the SSL/TLS support method."
  type        = string
}

variable "minimum_protocol_version" {
  description = "The minimum SSL/TLS protocol version that CloudFront can use."
  type        = string
}

variable "restriction_type" {
  description = "The restriction type for geographic restrictions."
  type        = string
}

variable "type" {
  description = "The type of cache behavior."
  type        = string
}

variable "evaluate_target_health" {
  description = "Indicates whether to evaluate the target health of an origin."
  type        = bool
}

variable "cloudfront_certificate_arn" {
  description = "The ARN of the cloudfront certificate arn"
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

variable "route53_zone_id" {
  description = "The ID of the Route53 hosted zone."
  type        = string
}


