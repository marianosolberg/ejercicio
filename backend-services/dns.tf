variable "dns_parent_zone_name" {
  description = "DNS zone of parent domain that will delegate NS records to this cluster zone (e.g. `prod.example.co`)"
}

module "dns" {
  source           = "git::https://github.com/cloudposse/terraform-aws-route53-cluster-zone.git?ref=tags/0.14.0"
  enabled          = true
  namespace        = var.namespace
  stage            = var.stage
  name             = var.name
  parent_zone_name = var.dns_parent_zone_name
  zone_name        = "$${region}-$${name}.$${parent_zone_name}"
}

output "dns_zone_id" {
  value = module.dns.zone_id
}

output "dns_zone_name" {
  value = module.dns.zone_name
}

output "dns_parent_zone_id" {
  value = module.dns.parent_zone_id
}

output "dns_parent_zone_name" {
  value = module.dns.parent_zone_name
}