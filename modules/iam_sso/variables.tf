variable "users" {
  description = "Map of users to create in the identity store."
  type = map(object({
    name = object({
      given_name  = string
      family_name = string
    })
    email             = string
    group_memberships = optional(list(string))
    account_assignments = optional(list(object({
      permission_set_name = string
      account_number      = string
    })))
  }))
  default = {}
}

variable "groups" {
  description = "Map of groups to create in the identity store."
  type = map(object({
    description = string
    account_assignments = optional(list(object({
      permission_set_name = string
      account_number      = string
    })))
  }))
  default = {}
}

variable "permission_sets" {
  description = "Map of permission sets to create in the identity store."
  type = list(object({
    name                = string
    description         = string
    policy_attachments  = optional(list(string))
    managed_policy_arns = optional(list(string))
    inline_policy       = optional(string, "")
    relay_state         = optional(string, "")
    session_duration    = optional(string, "")
    tags                = optional(map(string), {})
    customer_managed_policy_attachments = optional(list(object({
      name = string
      path = optional(string, "/")
    })), [])
  }))
  default = []
}
