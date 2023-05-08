variable "name" {
  description = "The name of the Cloud Front Function"
  type        = string
}

variable "basic_auth" {
  description = "List of base64 encoded credentials for Basic Auth"
  type        = list(string)
}
