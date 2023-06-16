variable "vpc_cidr_block" {
  type        = string
  description = "CIDR for the VPC"
}

variable "instance_tenancy" {
  type        = string
  description = "A tenancy option for instances launched into the VPC"
  default     = "default"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of Availability Zones where subnets will be created"
  default     = []
}

data "aws_availability_zones" "available" {
  exclude_names = var.az_exclude_names
}

locals {
  availability_zones = length(var.availability_zones) == 0 ? data.aws_availability_zones.available.names : var.availability_zones
}

module "vpc" {
  source                         = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=tags/1.1.0"
  namespace                      = var.namespace
  stage                          = var.stage
  name                           = var.name
  delimiter                      = var.delimiter
  attributes                     = var.attributes
  tags                           = var.tags
  cidr_block                     = var.vpc_cidr_block
  instance_tenancy               = var.instance_tenancy
  enable_dns_hostnames           = true
  enable_dns_support             = true
  enable_classiclink             = false
  enable_classiclink_dns_support = false
}

module "subnets" {
  source                  = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=tags/2.0.0-rc1"
  availability_zones      = local.availability_zones
  namespace               = var.namespace
  stage                   = var.stage
  name                    = var.name
  delimiter               = var.delimiter
  attributes              = var.attributes
  tags                    = var.tags
  vpc_id                  = module.vpc.vpc_id
  igw_id                  = [module.vpc.igw_id]
  cidr_block              = module.vpc.vpc_cidr_block
  map_public_ip_on_launch = true
  nat_gateway_enabled     = var.nat_gateway_for_subnets
  nat_instance_enabled    = false
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_default_security_group_id" {
  value = module.vpc.vpc_default_security_group_id
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "vpc_igw_id" {
  value = module.vpc.igw_id
}

output "vpc_public_subnet_ids" {
  value = module.subnets.public_subnet_ids
}

output "vpc_private_subnet_ids" {
  value = module.subnets.private_subnet_ids
}

output "vpc_public_subnet_cidrs" {
  value = module.subnets.public_subnet_cidrs
}

output "vpc_private_subnet_cidrs" {
  value = module.subnets.private_subnet_cidrs
}

output "vpc_public_route_table_ids" {
  value = module.subnets.public_route_table_ids
}

output "vpc_private_route_table_ids" {
  value = module.subnets.private_route_table_ids
}
