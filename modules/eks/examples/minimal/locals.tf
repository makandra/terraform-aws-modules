locals {
  az_names = slice(data.aws_availability_zones.available.names, 0, var.num_azs)
  # splitting the VPC CIDR depending on the number of AZs
  subnets = [for index, _ in concat(local.az_names, local.az_names) : cidrsubnet(
    var.vpc_cidr,
    ceil(log(var.num_azs * 2, 2)), # times two because we want public and private subnets
    index)
  ]
  cluster_name = "test-cluster"
  region       = "eu-west-1"
}
