module "kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "3.1.0"

  create                = var.create_kms_key
  aliases               = ["cloudtrail-${local.region}"]
  description           = "CloudTrail encryption"
  enable_default_policy = true

  key_statements = [
    {
      sid = "Allow CloudTrail to encrypt logs"
      actions = [
        "kms:GenerateDataKey*"
      ]
      resources = ["*"]
      principals = [
        {
          type        = "Service"
          identifiers = ["cloudtrail.amazonaws.com"]
        }
      ]
      conditions = [
        {
          test     = "StringEquals"
          variable = "aws:SourceArn"
          values   = ["arn:aws:cloudtrail:${local.region}:${local.account_id}:trail/${local.cloudtrail_name}"]
        },
        {
          test     = "StringLike"
          variable = "kms:EncryptionContext:aws:cloudtrail:arn"
          values   = ["arn:aws:cloudtrail:*:${local.account_id}:trail/*"]
        }
      ]
    },
    {
      sid = "Allow CloudTrail to describe key"
      actions = [
        "kms:DescribeKey"
      ]
      resources = ["*"]
      principals = [
        {
          type        = "Service"
          identifiers = ["cloudtrail.amazonaws.com"]
        }
      ]
    },
    {
      sid = "Allow principals in the account to decrypt log files"
      actions = [
        "kms:Decrypt",
        "kms:ReEncryptFrom"
      ]
      resources = ["*"]
      principals = [
        {
          type        = "AWS"
          identifiers = ["*"]
        }
      ]
      conditions = [
        {
          test     = "StringEquals"
          variable = "kms:CallerAccount"
          values   = [local.account_id]
        },
        {
          test     = "StringLike"
          variable = "kms:EncryptionContext:aws:cloudtrail:arn"
          values   = ["arn:aws:cloudtrail:*:${local.account_id}:trail/*"]
        }
      ]
    },
    {
      sid = "Allow alias creation during setup"
      actions = [
        "kms:CreateAlias"
      ]
      resources = ["arn:aws:kms:region:${local.account_id}:key/*"]
      principals = [
        {
          type        = "AWS"
          identifiers = ["*"]
        }
      ]
      conditions = [
        {
          test     = "StringEquals"
          variable = "kms:ViaService"
          values   = ["ec2.us-east-1.amazonaws.com"]
        },
        {
          test     = "StringEquals"
          variable = "kms:CallerAccount"
          values   = [local.account_id]
        }
      ]
    },
    {
      sid = "Allow CloudTrail to encrypt event data store"
      actions = [
        "kms:GenerateDataKey*",
        "kms:Decrypt"
      ]
      resources = ["*"]
      principals = [
        {
          type        = "Service"
          identifiers = ["cloudtrail.amazonaws.com"]
        }
      ]
    }
  ]
}
