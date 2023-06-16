variable "region" {
  type    = string
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources"
}

variable "vpc_id" {
  type = string
}

variable "vpc_private_subnet_ids" {
  type = list(string)
}

variable "ssm_prefix" {
  type    = string
  default = ""
}

variable "admin_username" {
  type        = string
  description = " admin user name"
  default     = ""
}

variable "admin_password" {
  type        = string
  description = " password for the admin user"
  default     = ""
}

variable "db_name" {
  type        = string
  description = " database name"
  default     = ""
}

variable "engine" {
  type        = string
  description = "engine"
}

variable "engine_mode" {
  type        = string
  default     = "provisioned"
  description = "The database engine mode. Valid values: `parallelquery`, `provisioned`, `serverless`"
}

variable "engine_version" {
  type        = string
  description = "Database Engine Version for Aurora PostgeSQL"
  default     = "11.6"
}

variable "cluster_family" {
  type        = string
  description = "Database Engine Version for Aurora PostgeSQL"
  default     = "aurora-ql11"
}

variable "instance_type" {
  type        = string
  default     = "db.r4.large"
  description = "EC2 instance type for  cluster"
}

variable "cluster_size" {
  type        = number
  default     = 2
  description = " cluster size"
}

variable "retention_period" {
  type        = number
  default     = 14
  description = "Number of days to retain backups for"
}

variable "backup_window" {
  type        = string
  default     = "07:00-09:00"
  description = "Daily time range during which the backups happen"
}

variable "maintenance_window" {
  type        = string
  default     = "wed:03:00-wed:04:00"
  description = "Weekly time range during which system maintenance can occur, in UTC"
}

variable "scaling_configuration" {
  type = list(object({
    auto_pause               = bool
    max_capacity             = number
    min_capacity             = number
    seconds_until_auto_pause = number
    timeout_action           = string
  }))
  default     = []
  description = "List of nested attributes with scaling properties. Only valid when `engine_mode` is set to `serverless`"
}

variable "timeouts_configuration" {
  type = list(object({
    create = string
    update = string
    delete = string
  }))
  default     = []
  description = "List of timeout values per action. Only valid actions are `create`, `update` and `delete`"
}

variable "autoscaling_enabled" {
  type        = bool
  default     = false
  description = "Set true to enable the database cluster autoscaler"
}

variable "autoscaling_min_capacity" {
  type        = number
  default     = 1
  description = "Minimum number of  instances to be maintained by the autoscaler"
}

variable "autoscaling_max_capacity" {
  type        = number
  default     = 6
  description = "Maximum number of  instances to be maintained by the autoscaler"
}

variable "monitoring_interval" {
  type    = number
  default = 30
}

variable "security_groups" {
  type        = list(string)
  default     = []
  description = "List of security groups to be allowed to connect to the DB instance"
}

variable "cloudwatch_logs_exports" {
  type        = list(string)
  description = "List of log types to export to cloudwatch. The following log types are supported: audit, error, general, slowquery"
  default     = []
}

variable "deletion_protection" {
  type        = bool
  description = "If the DB instance should have deletion protection enabled"
  default     = false
}

variable "apply_immediately" {
  type        = bool
  description = "Specifies whether any cluster modifications are applied immediately, or during the next maintenance window"
  default     = true
}

variable "enable_http_endpoint" {
  type        = bool
  description = "Enable HTTP endpoint (data API). Only valid when engine_mode is set to serverless"
  default     = false
}

variable "serverlessv2_scaling_configuration" {
  type = object({
    min_capacity = number
    max_capacity = number
  })
  default     = null
  description = "serverlessv2 scaling properties"
}

variable "auto_minor_version_upgrade" {
  type        = bool
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window"
  default     = false
}

variable "performance_insights_enabled" {
  type        = bool
  description = "Whether to enable Performance Insights."
  default     = false
}

variable "performance_insights_retention_period" {
  type    = number
  default = null
  description = "Amount of time in days to retain Performance Insights data."
}