resource "random_password" "admin_password" {
  length  = 26
  special = false
}

locals {
  port           = 5432
  db_name        = var.db_name
  admin_username = var.admin_username
  admin_password = length(var.admin_password) > 0 ? var.admin_password : random_password.admin_password.result
}



module "aurora" {
  source          = "git::https://github.com/cloudposse/terraform-aws-rds-cluster.git?ref=tags/1.3.2"
  enabled         = var.enabled
  engine          = var.engine
  engine_mode     = var.engine_mode
  engine_version  = var.engine_version
  cluster_family  = var.cluster_family
  cluster_size    = var.cluster_size
  namespace       = module.label.namespace
  stage           = module.label.stage
  name            = module.label.name
  attributes      = module.label.attributes
  tags            = module.label.tags
  admin_user      = local.admin_username
  admin_password  = local.admin_password
  db_name         = local.db_name
  db_port         = local.port
  instance_type   = var.instance_type
  security_groups = var.security_groups
  vpc_id          = var.vpc_id
  subnets         = var.vpc_private_subnet_ids

  retention_period    = var.retention_period
  backup_window       = var.backup_window
  maintenance_window  = var.maintenance_window
  skip_final_snapshot = true

  publicly_accessible  = false
  enable_http_endpoint = var.enable_http_endpoint
  apply_immediately    = var.apply_immediately
  deletion_protection  = var.deletion_protection

  enabled_cloudwatch_logs_exports = var.cloudwatch_logs_exports

  timeouts_configuration   = var.timeouts_configuration
  scaling_configuration    = var.scaling_configuration
  autoscaling_enabled      = var.autoscaling_enabled
  autoscaling_min_capacity = var.autoscaling_min_capacity
  autoscaling_max_capacity = var.autoscaling_max_capacity


  serverlessv2_scaling_configuration = var.serverlessv2_scaling_configuration
  auto_minor_version_upgrade         = var.auto_minor_version_upgrade

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period
}
