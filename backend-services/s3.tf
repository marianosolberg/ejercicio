module "s3_bucket" {
  source    = "git::https://github.com/cloudposse/terraform-aws-s3-bucket.git?ref=tags/3.0.0"
  name      = module.label.name
  stage     = module.label.stage
  namespace = module.label.namespace
  tags      = module.label.tags
}

resource "aws_s3_object" "folders" {
  count  = length(var.s3_forders_to_config_files)
  bucket = module.s3_bucket.bucket_id
  acl    = "private"
  key    = var.s3_forders_to_config_files[count.index]
  source = "/dev/null"
}

output "aws_s3_bucket_backend" {
  value = module.s3_bucket.bucket_id
}