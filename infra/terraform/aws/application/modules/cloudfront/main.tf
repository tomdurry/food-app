resource "aws_cloudfront_distribution" "frontend_distribution" {
  origin {
    domain_name = var.bucket_domain_name
    origin_id   = var.origin_id

    s3_origin_config {
      origin_access_identity = var.oai_cloudfront_access_identity_path
    }
  }

  enabled             = var.enabled
  default_root_object = var.default_root_object
  aliases             = [var.domain_name]

  default_cache_behavior {
    allowed_methods  = var.allowed_methods
    cached_methods   = var.cached_methods
    target_origin_id = var.target_origin_id

    forwarded_values {
      query_string = var.query_string

      cookies {
        forward = var.forward
      }
    }

    viewer_protocol_policy = var.viewer_protocol_policy
  }

  custom_error_response {
    error_code         = var.error_code
    response_code      = var.response_code
    response_page_path = var.response_page_path
  }

  viewer_certificate {
    acm_certificate_arn      = var.cloudfront_certificate_arn
    ssl_support_method       = var.ssl_support_method
    minimum_protocol_version = var.minimum_protocol_version
  }

  restrictions {
    geo_restriction {
      restriction_type = var.restriction_type
    }
  }

  tags = {
    Project     = var.project
    Environment = var.environment
    Resource    = "CloudFront Distribution"
  }
}

resource "aws_route53_record" "frontend_alias" {
  zone_id = var.route53_zone_id
  name    = var.domain_name
  type    = var.type

  alias {
    name                   = aws_cloudfront_distribution.frontend_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.frontend_distribution.hosted_zone_id
    evaluate_target_health = var.evaluate_target_health
  }
}
