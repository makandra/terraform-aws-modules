variable "kms_key_arn" {
  description = "The ARN of the KMS key to use for encryption of cloudtrail. If no ARN is provided cloudtrail won't be encrypted."
  type        = string
  default     = null
}
