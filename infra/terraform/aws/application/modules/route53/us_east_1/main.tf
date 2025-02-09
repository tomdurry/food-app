resource "aws_route53_record" "frontend_certificate_validation" {
  for_each = {
    for dvo in var.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = data.aws_route53_zone.food_app_zone.id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = var.ttl
}

resource "aws_acm_certificate_validation" "cloudfront_certificate_validation" {
  certificate_arn         = var.cloudfront_certificate_arn
  validation_record_fqdns = [for r in aws_route53_record.frontend_certificate_validation : r.fqdn]
}
