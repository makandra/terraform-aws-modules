module "RDSOS_KMS" {
  source = "../.."

  log_rentention_days = 7
  create_kms_key      = false
  kms_key_id          = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
}
