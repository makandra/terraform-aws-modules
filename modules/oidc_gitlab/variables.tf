variable "gitlab_url" {
  description = "URL of your gitlab instance."
  type        = string
  default     = "https://gitlab.com"
}

variable "match_field" {
  description = "Variable attribute for the condition block of the assume role policy. See the [GitLab documentation](https://docs.gitlab.com/ci/cloud_services/aws/#configure-a-role-and-trust) for possbile values"
  type        = string
  default     = "sub"
}

variable "match_value" {
  description = "Value for the condition block of the assume role policy. See the [GitLab documentation](https://docs.gitlab.com/ci/cloud_services/aws/#configure-a-role-and-trust) for possbile values"
  type        = list(any)
}

variable "policies" {
  description = "List of policy ARNs to attach to the role"
  type        = set(string)
  default     = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
}

variable "role_name" {
  description = "Name of the created IAM role"
  type        = string
  default     = "Gitlab"
}

variable "thumbprint_list" {
  description = "List of server certificate thumbprints for the OpenID Connect (OIDC) identity provider's server certificate(s). Required for AWS provider versions <5.81.0! See the [provider documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) for more information."
  type        = set(string)
  default     = null
}
