locals {
  role_mappings = [
    for role, groups in var.iam_role_rbac_mappings : {
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${role}"
      username = role
      groups   = groups
    }
  ]

  user_mappings = [
    for user, groups in var.iam_user_rbac_mappings : {
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${user}"
      username = user
      groups   = groups
    }
  ]

  node_group_iam_roles = [for ng in module.eks_managed_node_group : ng.iam_role_name]
  asg_tags = [
    for ng, values in var.node_groups : {
      asg_name  = module.eks_managed_node_group[ng].node_group_resources[0].autoscaling_groups[0].name
      tag_value = ng
    }
  ]
}
