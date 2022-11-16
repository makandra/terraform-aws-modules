variable "create_kms_key" {
  description = "Whether to create a KMS key for encrypting the loggroup."
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "The alias of the KMS key to use for encrypting the CloudWatch log groups. If this is set this key if prefered over the created one (which should be disabled then)."
  type        = string
  default     = null
}

variable "log_rentention_days" {
  description = "The number of days to retain log events in the log group."
  type        = number
  default     = 30
  validation {
    condition     = contains([0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.log_rentention_days)
    error_message = "Invalid value for log_retention days '${var.log_rentention_days}'. Valid values are: [0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653]"
  }
}
