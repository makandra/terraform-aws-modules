module "eks" {
  source = "../.."

  cluster_endpoint_public_access = true # WARNING: This is not recommended for production clusters. You should setup a private connection to your VPC instead.
  cluster_version                = "1.25"
  cluster_name                   = local.cluster_name
  region                         = local.region
  vpc_id                         = module.vpc.vpc_id
  private_subnet_ids             = module.vpc.private_subnets
  iam_user_rbac_mappings = {
    "some_user" = [
      "system:masters"
    ]
  }
  node_groups = {
    t_spot = {
      min_size      = 2,
      max_size      = 10,
      desired_size  = 2,
      volume_size   = 20,
      capacity_type = "SPOT",
      instance_types = [
        "t2.large",
        "t3.large",
        "t3a.large"
      ]
    },
    compute_demand = {
      min_size      = 0,
      max_size      = 5,
      desired_size  = 1,
      volume_size   = 20,
      capacity_type = "ON_DEMAND",
      instance_types = [
        "c6i.xlarge",
        "c6a.xlarge",
        "c5.xlarge",
        "c5a.xlarge"
      ]
      taints = [
        {
          key    = "compute_on_demand"
          value  = "true"
          effect = "NO_SCHEDULE"
        }
      ]
    }
  }
}
