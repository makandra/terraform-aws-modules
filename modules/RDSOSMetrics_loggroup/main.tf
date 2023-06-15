locals {
  module_kms_key = var.create_kms_key ? aws_kms_key.RDSOS_KMS[0].arn : null
  kms_key_id     = var.kms_key_id == null ? local.module_kms_key : var.kms_key_id
}

resource "aws_cloudwatch_log_group" "this" {
  #checkov:skip=CKV_AWS_338:Logs retention time does not always have to be at least 1 year
  name              = "RDSOSMetrics"
  retention_in_days = var.log_rentention_days
  kms_key_id        = local.kms_key_id
}
