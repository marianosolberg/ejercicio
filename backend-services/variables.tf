variable "region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "s3_forders_to_config_files" {
  type        = list(string)
  default     = []
  description = "S3 Buckets to config files (jenkins, app, etc)"
}

variable "az_exclude_names" {
  type        = list(string)
  default     = []
}

variable "nat_gateway_for_subnets" {
  type        = bool
  default     = true
}