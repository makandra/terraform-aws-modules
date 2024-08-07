data "aws_iam_policy_document" "eks_ebs" {
  #checkov:skip=CKV_AWS_111: Does not apply here because KMS key policies only apply to the key itself. (https://docs.bridgecrew.io/docs/ensure-iam-policies-do-not-allow-write-access-without-constraint)
  #checkov:skip=CKV_AWS_109: Does not apply here because KMS key policies only apply to the key itself. (https://docs.bridgecrew.io/docs/ensure-iam-policies-do-not-allow-permissions-management-resource-exposure-without-constraint)
  #checkov:skip=CKV_AWS_356:Does not apply here because KMS key policies only apply to the key itself.
  statement {
    sid       = "Enable IAM User Permissions"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

  # Required for EKS
  statement {
    sid = "Allow service-linked role use of the CMK"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        # required for the ASG to manage encrypted volumes for nodes
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling",
        # required for the cluster / persistentvolume-controller to create encrypted PVCs
        module.eks.cluster_iam_role_arn,
      ]
    }
  }

  statement {
    sid       = "Allow attachment of persistent resources"
    actions   = ["kms:CreateGrant"]
    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        # required for the ASG to manage encrypted volumes for nodes
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling",
        # required for the cluster / persistentvolume-controller to create encrypted PVCs
        module.eks.cluster_iam_role_arn,
      ]
    }

    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }
  }
}

resource "aws_kms_key" "eks" {
  #checkov:skip=CKV2_AWS_64: We do not need a resource policy for this key
  description             = "EKS Secret Encryption Key"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_kms_alias" "eks_secrets" {
  name          = "alias/eks_secrets-${var.cluster_name}"
  target_key_id = aws_kms_key.eks.arn
}

resource "aws_kms_key" "ebs" {
  description             = "Customer managed key to encrypt EKS managed node group volumes"
  deletion_window_in_days = 7
  policy                  = data.aws_iam_policy_document.eks_ebs.json
  enable_key_rotation     = true
  depends_on              = [null_resource.ensure_role_exists]
}

resource "aws_kms_alias" "eks_ebs" {
  name          = "alias/eks_ebs-${var.cluster_name}"
  target_key_id = aws_kms_key.ebs.arn
}

resource "aws_kms_key" "eks_logging" {
  description             = "KMS key to encrypt Cloudwatch loggroups."
  deletion_window_in_days = 7
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.eks_logging.json
}

resource "aws_kms_alias" "eks_logging" {
  name          = "alias/eks-loggroups-kms"
  target_key_id = aws_kms_key.eks_logging.arn
}

data "aws_iam_policy_document" "eks_logging" {
  #checkov:skip=CKV_AWS_111: Does not apply here because KMS key policies only apply to the key itself. (https://docs.bridgecrew.io/docs/ensure-iam-policies-do-not-allow-write-access-without-constraint)
  #checkov:skip=CKV_AWS_109: Does not apply here because KMS key policies only apply to the key itself. (https://docs.bridgecrew.io/docs/ensure-iam-policies-do-not-allow-permissions-management-resource-exposure-without-constraint)
  #checkov:skip=CKV_AWS_356:Does not apply here because KMS key policies only apply to the key itself.
  policy_id = "key-policy-cloudwatch"
  statement {
    sid = "Enable IAM User Permissions"
    actions = [
      "kms:*",
    ]
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
      ]
    }
    resources = ["*"]
  }
  statement {
    sid = "AllowCloudWatchLogs"
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "logs.${var.region}.amazonaws.com",
      ]
    }
    resources = ["*"]
  }
}
