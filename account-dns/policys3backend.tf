data "aws_s3_bucket" "stateterra" {
}

resource "aws_s3_bucket_policy" "addsecpolicy" {
  bucket = data.aws_s3_bucket.stateterra.id
  policy = data.aws_iam_policy_document.allowonlyadminroles.json
}

data "aws_iam_policy_document" "allowonlyadminroles" {
  statement {
    sid    = "EnforcedTLS"
    effect = "Deny"

    resources = [
      data.aws_s3_bucket.stateterra.arn,
      format("%s/*", data.aws_s3_bucket.stateterra.arn)
    ]

    actions = ["s3:*"]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }

  statement {
    sid    = "Deny explicit"
    effect = "Deny"

    resources = [
      data.aws_s3_bucket.stateterra.arn,
      format("%s/*", data.aws_s3_bucket.stateterra.arn)
    ]

    actions = ["s3:*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "StringNotEquals"
      variable = "aws:PrincipalArn"
      values = [format("arn:aws:iam::%s:role/tapi-%s-deploy-runner-task", var.account_id, var.stage),
        format("arn:aws:iam::%s:role/OrganizationAccountAccessRole", var.account_id),
        format("arn:aws:iam::%s:role/tapi-%s-role-god-%s", var.account_id, var.stage, var.stage)

      ]
    }
  }
}