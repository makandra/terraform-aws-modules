data "aws_caller_identity" "current" {}

module "s3-bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.6.0"

  bucket_prefix           = "cloudtrail-${data.aws_caller_identity.current.account_id}-"
  acl                     = "private"
  attach_policy           = true
  policy                  = data.aws_iam_policy_document.bucket_policy.json
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }

  lifecycle_rule = [
    {
      id      = "expire-old-files"
      enabled = true
      filter = {
        prefix = "/"
      }
      expiration = {
        days = 365
      }
      noncurrent_version_expiration = {
        days = 180
      }
    }
  ]

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid = "AWSCloudTrailAclCheck"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions = [
      "s3:GetBucketAcl",
    ]
    resources = [
      module.s3-bucket.s3_bucket_arn,
    ]
  }

  statement {
    sid = "AWSCloudTrailWrite"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com", "config.amazonaws.com"]
    }
    actions = [
      "s3:PutObject",
    ]
    resources = [
      module.s3-bucket.s3_bucket_arn,
    ]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values = [
        "bucket-owner-full-control",
      ]
    }
  }
}

resource "aws_cloudtrail" "this" {
  name                          = "cloudtrail-${data.aws_caller_identity.current.account_id}"
  enable_log_file_validation    = true
  enable_logging                = true
  include_global_service_events = true
  is_multi_region_trail         = true
  s3_bucket_name                = module.s3-bucket.s3_bucket_id
  kms_key_id                    = var.kms_key_arn
}
