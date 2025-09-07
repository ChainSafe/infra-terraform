resource "aws_acm_certificate" "this" {
  count = var.enable_public_zone ? 1 : 0

  domain_name       = "*.${local.zone_name}"
  validation_method = "DNS"

  tags = merge(
    var.tags,
    {
      Name = local.zone_name
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "this" {
  for_each = var.enable_public_zone ? {
    for dvo in aws_acm_certificate.this[0].domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}

  name            = each.value.name
  type            = each.value.type
  zone_id         = aws_route53_zone.this[0].zone_id
  allow_overwrite = true
  ttl             = 300

  records = [
    each.value.record
  ]
}

resource "aws_acm_certificate_validation" "this" {
  count = var.enable_public_zone ? 1 : 0

  certificate_arn = aws_acm_certificate.this[0].arn

  validation_record_fqdns = [
    for record in aws_route53_record.this :
    record.fqdn
  ]

  timeouts {
    create = "10m"
  }

  depends_on = [
    cloudflare_dns_record.this
  ]
}
