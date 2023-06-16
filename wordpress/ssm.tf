  module "ssm_association_ansible_label" {
    source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.25.0"
    context    = module.label.context
    attributes = ["ssm", "association", "ansible"]
  }

  locals {
    ansible_variables = [
      "aws_region=${var.region}",
      "aws_ssm_module=/${module.label.id}",
      "re_run_playbook=${var.re_run_playbook}",
    ]
  }

  resource "aws_ssm_association" "ansible_playbook" {
    name = "AWS-ApplyAnsiblePlaybooks"

    association_name    = module.ssm_association_ansible_label.id
    compliance_severity = "CRITICAL"
    max_errors          = 0
    max_concurrency     = "50%"

    targets {
      key    = "InstanceIds"
      values = values(aws_instance.wordpress)[*].id 
    }

    output_location {
      s3_bucket_name = aws_s3_bucket.provision.id
      s3_key_prefix  = "logs"
    }

    schedule_expression = var.ssm_association_schedule_expression

    parameters = {
      SourceType          = "S3"
      SourceInfo          = jsonencode({ path = "https://${aws_s3_bucket.provision.bucket_regional_domain_name}/${aws_s3_object.ansible.key}" })
      InstallDependencies = "True"
      PlaybookFile        = "provision.yml"
      ExtraVariables      = "${join(" ", local.ansible_variables)}"
      Check               = "False"
      Verbose             = "-v"
    }
  }
