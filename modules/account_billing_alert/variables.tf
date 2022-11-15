variable "monthly_budget" {
  description = "This is the monthly budget for the costs of the whole account in USD. Setting to 0 disables the budget."
  type        = number
}

variable "monthly_threshold" {
  description = "An alarm will be sent if forecasted costs for the month are more than x% of the budget. This variable sets x."
  type        = number
  default     = 80
  validation {
    condition     = var.monthly_threshold >= 0 && var.monthly_threshold < 100
    error_message = "The monthly_threshold must be higher than 0% and lower than 100%."
  }
}

variable "daily_budget" {
  description = "This is the daily budget for the costs of the whole account in USD. Setting to 0 disables the budget."
  type        = number
}

variable "daily_threshold" {
  description = "An alarm will be sent if the actual costs for the day are more than x% of the budget. This variable sets x."
  type        = number
  default     = 99
  validation {
    condition     = var.daily_threshold >= 0 && var.daily_threshold < 100
    error_message = "The daily_threshold must be higher than 0% and lower than 100%."
  }
}

variable "anomaly_detection_threshold" {
  description = "The anomaly detection threshold in USD. If the costs vary that much from usual costs in the pasts a notification is sent. Setting to 0 disables anomaly detection."
  type        = number
}

variable "alarm_mail_recipients" {
  description = "A list of e-mail recipients who receive an email when one of the thresholds is reached."
  type        = list(string)
  validation {
    condition     = can([for i in var.alarm_mail_recipients : regex("^[\\w+.-]+\\@[\\w+.-]+\\.\\w+$", i)])
    error_message = "Input must be alist of mail addresses."
  }
}
