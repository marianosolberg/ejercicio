output "aurora_endpoint_ssm_parameter_arn" {
  value       = aws_ssm_parameter.aurora_endpoint.arn
  description = "Aurora Endpoint SSM Parameter ARN"
}

output "aurora_reader_endpoint_ssm_parameter_arn" {
  value       = aws_ssm_parameter.aurora_reader_endpoint.arn
  description = "Aurora Reader Endpoint SSM Parameter ARN"
}

output "aurora_port_ssm_parameter_arn" {
  value       = aws_ssm_parameter.aurora_port.arn
  description = "Aurora Port SSM Parameter ARN"
}

output "aurora_master_username_ssm_parameter_arn" {
  value       = aws_ssm_parameter.aurora_master_username.arn
  description = "Aurora Username SSM Parameter ARN"
}

output "aurora_master_password_ssm_parameter_arn" {
  value       = aws_ssm_parameter.aurora_master_password.arn
  description = "Aurora Password SSM Parameter ARN"
}

output "aurora_security_group_id" {
  value       = flatten(module.aurora.cluster_security_groups)[0]
  description = "Aurora Security Group ID"
}
