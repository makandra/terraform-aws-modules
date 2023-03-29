variable "assign_contacts_to_all_accounts" {
  description = "If true, assign the alternate contacts to all accounts in the organization."
  type        = bool
  default     = false
}

variable "filter_accounts" {
  description = "A list of account IDs to filter the list of accounts to assign alternate contacts to. This is only relevant if assign_contacts_to_all_accounts is true."
  type        = list(string)
  default     = []
}

variable "default_alternate_contact" {
  description = "These defaults are used for all alternate contacts if no specifics are given."
  type = object({
    name          = string
    title         = string
    email_address = string
    phone_number  = string
  })
}

variable "billing_contact" {
  description = "Contact data for the billing contact."
  type = object({
    name          = string
    title         = string
    email_address = string
    phone_number  = string
  })
  default = null
}

variable "operations_contact" {
  description = "Contact data for the operations contact."
  type = object({
    name          = string
    title         = string
    email_address = string
    phone_number  = string
  })
  default = null
}

variable "security_contact" {
  description = "Contact data for the security contact."
  type = object({
    name          = string
    title         = string
    email_address = string
    phone_number  = string
  })
  default = null
}
