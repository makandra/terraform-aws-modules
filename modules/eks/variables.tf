variable "cluster_version" {
  description = "EKS version to use. See https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
}

variable "region" {
  description = "The region where ressources should be managed."
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID EKS will be attached to."
  type        = string
}

variable "private_subnet_ids" {
  description = "The private subnet IDs EKS nodes are attached to."
  type        = list(string)
}

variable "iam_user_rbac_mappings" {
  description = "A map of IAM user names to map to Kubernetes RBAC roles. The key is the IAM user name, the value is is a list of the Kubernetes RBAC role names."
  type        = map(list(string))
  default     = {}
}

variable "iam_role_rbac_mappings" {
  description = "A map of IAM role names to map to Kubernetes RBAC roles. The key is the IAM role name, the value is is a list of the Kubernetes RBAC role names."
  type        = map(list(string))
  default     = {}
}

variable "node_groups" {
  description = "Node group definitions for the EKS cluster."
  type = map(object({
    min_size       = number
    max_size       = number
    desired_size   = number
    volume_size    = number
    capacity_type  = string
    instance_types = list(string)
    taints         = optional(any, [])
  }))
  validation {
    condition = alltrue([
    for o in var.node_groups : contains(["ON_DEMAND", "SPOT"], o.capacity_type)])
    error_message = "Capacity type must be ON_DEMAND or SPOT."
  }
}

variable "cluster_enabled_log_types" {
  description = "A list of the desired control plane logs to enable."
  type        = list(string)
  default     = ["audit", "api", "authenticator", "scheduler", "controllerManager"]
}

variable "cluster_endpoint_public_access" {
  description = "Whether or not to enable public access to the cluster endpoint."
  type        = bool
  default     = false
}
