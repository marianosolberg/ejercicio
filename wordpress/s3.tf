module "s3_bucket_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.25.0"
  context    = module.label.context
  attributes = ["provision", "bucket"]
}

data "archive_file" "ansible" {
  type        = "zip"
  source_dir  = "${path.module}/ansible/"
  output_path = "${path.module}/ansible.zip"
}

resource "aws_s3_bucket" "provision" {
  bucket = module.s3_bucket_label.id
  tags = module.s3_bucket_label.tags
}

resource "aws_s3_bucket_lifecycle_configuration" "provision" {
  bucket = aws_s3_bucket.provision.id
  rule {
    id = "logs"
    
    filter {
      and {
        prefix = "logs/"
        tags = {
          Key1 = "Value1"
          Key2 = "Value2"
        }
      }
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }

    expiration {
      days = 90
    }


    status = "Enabled"
  }
}


resource "aws_s3_object" "ansible" {
  bucket = aws_s3_bucket.provision.id
  key    = "ansible.zip"
  source = data.archive_file.ansible.output_path
  etag   = data.archive_file.ansible.output_base64sha256
}
