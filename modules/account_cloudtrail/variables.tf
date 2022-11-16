variable "kms_key_arn" {
  description = "The ARN of the KMS key to use for encryption of cloudtrail. If no ARN is provided cloudtrail won't be encrypted."
  type        = string
  default     = null
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket to store cloudtrail logs in. This is optional and defaults to a prefix with cloudtrail-<ACCOUNTID>-."
  type        = string
  default     = null
}

variable "cloudtrail_name" {
  description = "The name of the cloudtrail. This is optional and defaults to cloudtrail-<ACCOUNTID>."
  type        = string
  default     = null
}
