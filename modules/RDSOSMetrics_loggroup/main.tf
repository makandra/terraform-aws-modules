locals {
  module_kms_key = var.create_kms_key ? aws_kms_key.RDSOS_KMS[0].arn : null
  kms_key_id     = var.kms_key_id == null ? local.module_kms_key : var.kms_key_id
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "RDSOSMetrics"
  retention_in_days = var.log_rentention_days
  kms_key_id        = local.kms_key_id
}
