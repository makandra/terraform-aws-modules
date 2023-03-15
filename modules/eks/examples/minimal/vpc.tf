data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  #checkov:skip=CKV_AWS_111: Flowlog cloudwatch policy is fine
  #checkov:skip=CKV2_AWS_12: Not required to alter the default security group.
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.13.0"

  name = local.cluster_name
  cidr = var.vpc_cidr

  #azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  azs             = local.az_names
  private_subnets = slice(local.subnets, 0, var.num_azs)
  #checkov:skip=CKV_AWS_130: Public subnets should automatically assign public IPs
  public_subnets = slice(local.subnets, var.num_azs, var.num_azs * 2)

  enable_nat_gateway   = true
  single_nat_gateway   = var.single_nat_gateway
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
    "subnet_type"                                 = "public"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
    "subnet_type"                                 = "private"
  }

  private_route_table_tags = {
    "rt_type" = "private"
  }
}
