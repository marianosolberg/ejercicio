terraform {
  required_version = "~> 1.1.2"

  required_providers {
    aws = "~> 3.65"
  }
}

variable "domain_name" {
  type        = string
  description = "Domain name"
}

resource "aws_route53_zone" "dns_zone" {
  name = var.domain_name
}

resource "aws_route53_record" "dns_zone_soa" {
  allow_overwrite = true
  zone_id         = aws_route53_zone.dns_zone.id
  name            = aws_route53_zone.dns_zone.name
  type            = "SOA"
  ttl             = "60"

  records = [
    "${aws_route53_zone.dns_zone.name_servers.0}. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400",
  ]
}

output "zone_id" {
  value = aws_route53_zone.dns_zone.zone_id
}

output "name_servers" {
  value = aws_route53_zone.dns_zone.name_servers
}