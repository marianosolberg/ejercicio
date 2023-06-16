locals {
  ssm_prefix = coalesce(var.ssm_prefix, module.label.id)
}

resource "aws_ssm_parameter" "aurora_endpoint" {
  name      = format("/%s/%s/%s", local.ssm_prefix, module.label.name, "db_host")
  value     = module.aurora.endpoint
  type      = "SecureString"
  overwrite = true
}

resource "aws_ssm_parameter" "aurora_reader_endpoint" {
  name      = format("/%s/%s/%s", local.ssm_prefix, module.label.name, "db_reader_host")
  value     = coalesce(module.aurora.reader_endpoint, module.aurora.endpoint)
  type      = "SecureString"
  overwrite = true
}

resource "aws_ssm_parameter" "aurora_port" {
  name      = format("/%s/%s/%s", local.ssm_prefix, module.label.name, "db_port")
  value     = local.port
  type      = "SecureString"
  overwrite = true
}

resource "aws_ssm_parameter" "aurora_database_name" {
  name      = format("/%s/%s/%s", local.ssm_prefix, module.label.name, "db_name")
  value     = module.aurora.database_name
  type      = "SecureString"
  overwrite = true
}

resource "aws_ssm_parameter" "aurora_master_username" {
  name      = format("/%s/%s/%s", local.ssm_prefix, module.label.name, "db_user")
  value     = module.aurora.master_username
  type      = "SecureString"
  overwrite = true
}

resource "aws_ssm_parameter" "aurora_master_password" {
  name      = format("/%s/%s/%s", local.ssm_prefix, module.label.name, "db_password")
  value     = local.admin_password
  type      = "SecureString"
  overwrite = true
}
