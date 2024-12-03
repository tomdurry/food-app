
variable "certificate_arn" {
  description = "The ARN of the ACM certificate"
  type        = string
}

variable "domain_validation_options" {
  description = "List of domain validation options for creating Route53 records"
  type = list(object({
    domain_name           = string
    resource_record_name  = string
    resource_record_value = string
    resource_record_type  = string
  }))
}
