output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.frontend_bucket.bucket
}

output "frontend_bucket_id" {
  description = "The ID of the S3 bucket"
  value       = aws_s3_bucket.frontend_bucket.id
}

output "frontend_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.frontend_bucket.arn
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.frontend_bucket.arn
}

output "bucket_domain_name" {
  description = "The regional domain name of the S3 bucket"
  value       = aws_s3_bucket.frontend_bucket.bucket_regional_domain_name
}

output "bucket_tags" {
  description = "The tags of the S3 bucket"
  value       = aws_s3_bucket.frontend_bucket.tags
}
