resource "aws_cloudfront_distribution" "frontend_distribution" {
  origin {
    domain_name = var.bucket_domain_name
    origin_id   = "S3-Frontend-Origin"

    s3_origin_config {
      origin_access_identity = var.oai_cloudfront_access_identity_path
    }
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-Frontend-Origin"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }
  viewer_certificate {
    # cloudfront_default_certificate = true
    acm_certificate_arn      = var.certificate_validation_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }


  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = "prod"
  }
}

resource "aws_route53_record" "frontend_alias" {
  zone_id = var.route53_zone_id
  name    = "food-app-generation.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.frontend_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.frontend_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}


