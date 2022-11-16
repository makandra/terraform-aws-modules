resource "aws_kms_key" "RDSOS_KMS" {
  count                   = var.create_kms_key ? 1 : 0
  description             = "KMS key to encrypt Cloudwatch loggroup for RDSOSMetrics (enhanced monitoring)."
  deletion_window_in_days = 7
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.RDSOS_KMS[0].json
}

resource "aws_kms_alias" "RDSOS_KMS" {
  count         = var.create_kms_key ? 1 : 0
  name          = "alias/RDSOSMetrics"
  target_key_id = aws_kms_key.RDSOS_KMS[0].arn
}
