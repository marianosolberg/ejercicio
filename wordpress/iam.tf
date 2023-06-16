module "role_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.25.0"
  context    = module.label.context
  attributes = ["role"]
}

module "profile_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.25.0"
  context    = module.label.context
  attributes = ["profile"]
}

data "aws_iam_policy_document" "ssm_instance_profile_s3_policy" {
  statement {
    actions = [
      "s3:Get*",
      "s3:List*",
      "s3:PutObject"
    ]

    effect = "Allow"

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.provision.id}",
      "arn:aws:s3:::${aws_s3_bucket.provision.id}/*"
    ]
  }
}

resource "aws_iam_policy" "ssm_instance_profile_s3_policy" {
  name    = "${module.profile_label.id}-ssm-instance-profile-s3"
  tags    = module.profile_label.tags
  policy  = data.aws_iam_policy_document.ssm_instance_profile_s3_policy.json
}

data "aws_iam_policy_document" "role_trust" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "instance_role" {
  name               = module.role_label.id
  tags = module.role_label.tags
  assume_role_policy = data.aws_iam_policy_document.role_trust.json
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = module.profile_label.id
  role = aws_iam_role.instance_role.name
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ssm_instance_profile_s3_policy" {
  role       = aws_iam_role.instance_role.name
  policy_arn = aws_iam_policy.ssm_instance_profile_s3_policy.arn
}


data "aws_iam_policy_document" "ssm_instance_ssm_parameters_policy" {
  statement {
    actions = [
      "ssm:GetParameterHistory",
      "ssm:GetParametersByPath",
      "ssm:GetParameters",
      "ssm:GetParameter"
    ]

    effect = "Allow"
    
    resources = [
      format("arn:aws:ssm:%s:%s:parameter/%s", var.region, var.account_id, module.label.id),
      format("arn:aws:ssm:%s:%s:parameter/%s/*", var.region, var.account_id, module.label.id)
    ]
  }
}

resource "aws_iam_policy" "ssm_instance_ssm_parameters_policy" {
  name    = "${module.profile_label.id}-ssm-parameters-policy"
  tags    = module.profile_label.tags
  policy  = data.aws_iam_policy_document.ssm_instance_ssm_parameters_policy.json
}

resource "aws_iam_role_policy_attachment" "ssm_instance_ssm_parameters_policy" {
  role       = aws_iam_role.instance_role.name
  policy_arn = aws_iam_policy.ssm_instance_ssm_parameters_policy.arn
}
