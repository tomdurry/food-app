resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for CloudFront to access S3 bucket"
}
