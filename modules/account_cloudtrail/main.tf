data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  account_id      = data.aws_caller_identity.current.account_id
  cloudtrail_name = var.cloudtrail_name == null ? "cloudtrail-${local.account_id}" : var.cloudtrail_name
  kms_key_arn     = var.create_kms_key ? module.kms.key_arn : var.kms_key_arn
  region          = data.aws_region.current.region
  s3_encryption_configuration = local.kms_key_arn == null ? {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
    } : {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = local.kms_key_arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

module "s3-bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.11.0"

  bucket                  = var.s3_bucket_name
  bucket_prefix           = var.s3_bucket_name == null ? "cloudtrail-${local.account_id}-" : null
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
        days = var.s3_lifecycle_expiration
      }
      noncurrent_version_expiration = {
        days = var.s3_lifecycle_noncurrent_expiration
      }
    }
  ]

  server_side_encryption_configuration = local.s3_encryption_configuration
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
      "${module.s3-bucket.s3_bucket_arn}/*",
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
  #checkov:skip=CKV_AWS_252:This is optional and not required
  #checkov:skip=CKV2_AWS_10:This is optional and not required
  name                          = local.cloudtrail_name
  enable_log_file_validation    = true
  enable_logging                = true
  include_global_service_events = true
  is_multi_region_trail         = true
  s3_bucket_name                = module.s3-bucket.s3_bucket_id
  kms_key_id                    = local.kms_key_arn
}
