variable "num_azs" {
  description = "Number of availability zones that should be used."
  default     = 3
  type        = number
}

variable "vpc_cidr" {
  description = "CIDR for the automatically created VPC"
  type        = string
}

variable "single_nat_gateway" {
  description = "Wether to use a single NAT gateway for the VPC"
  type        = bool
  default     = true # for testing purposes
}
