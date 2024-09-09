variable "create_kms_key" {
  description = "Controls if a customer managed KMS key should be created"
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key to use for encryption of cloudtrail. If no ARN is provided and create_kms_key is not used cloudtrail won't be encrypted."
  type        = string
  default     = null
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket to store cloudtrail logs in. This is optional and defaults to a prefix with cloudtrail-<ACCOUNTID>-."
  type        = string
  default     = null
}

variable "s3_lifecycle_expiration" {
  description = "Days after which files get marked non-current from the expire lifecycle rule."
  type        = number
  default     = 365
}

variable "s3_lifecycle_noncurrent_expiration" {
  description = "Days after which non-current marked files get deleted from the expire lifecycle rule."
  type        = number
  default     = 180
}

variable "cloudtrail_name" {
  description = "The name of the cloudtrail. This is optional and defaults to cloudtrail-<ACCOUNTID>."
  type        = string
  default     = null
}
