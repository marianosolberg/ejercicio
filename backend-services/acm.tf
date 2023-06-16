variable "acm_request_certificate_enabled" {
  type    = bool
  default = true
}

module "acm_request_certificate" {
  depends_on                = [module.dns]
  source                    = "git::https://github.com/cloudposse/terraform-aws-acm-request-certificate.git?ref=tags/0.16.0"
  enabled                   = var.acm_request_certificate_enabled
  domain_name               = module.dns.zone_name
  ttl                       = 300
  subject_alternative_names = formatlist("*.%s", [module.dns.zone_name])
  tags                      = var.tags
}
