# The create command for this ASG will fail. But we require it to create the `AWSServiceRoleForAutoScaling`
# When provisioning the initial setup in a new accountthe AWSServiceRoleForAutoScaling is missing.
# Executing this command creates it.
resource "null_resource" "ensure_role_exists" {
  provisioner "local-exec" {
    command = "aws autoscaling create-auto-scaling-group --region ${var.region} --auto-scaling-group-name my-asg --min-size 0 --max-size 0 --launch-configuration-name dummy 2>&1 | grep -q 'Launch configuration name not found'"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.10.0"

  cluster_name                    = var.cluster_name
  cluster_version                 = var.cluster_version
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access

  cluster_addons = {
    coredns = {
      preserve    = true
      most_recent = true
    }
    kube-proxy = {
      preserve    = true
      most_recent = true
    }
    vpc-cni = {
      preserve    = true
      most_recent = true
    }
  }


  create_kms_key = false
  #checkov:skip=CKV_AWS_58: False positive; secrets encryption is enabled.
  cluster_encryption_config = {
    provider_key_arn = aws_kms_key.eks.arn
    resources        = ["secrets"]
  }
  cloudwatch_log_group_kms_key_id = aws_kms_key.eks_logging.arn

  vpc_id                    = var.vpc_id
  subnet_ids                = var.private_subnet_ids
  cluster_enabled_log_types = var.cluster_enabled_log_types

  # Security Group: Allow Egress to ephemeral TCP ports
  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }

  # Security Group: Node to Node communication
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
  }

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = ["t3.small"]
  }

  #checkov:skip=CKV_AWS_79: False positive, the module already sets the `http_tokens` parameter to `required` as default, see https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/18.30.2/submodules/eks-managed-node-group
  #checkov:skip=CKV_AWS_111: False positive; the mentioned policy for the instances to allow tagging and assigning IPv6 addresses is fine.
  #checkov:skip=CKV2_AWS_5: Security group "module.eks.module.eks.aws_security_group.node" is referenced in other modules
  eks_managed_node_groups = {}

  # aws-auth configmap
  manage_aws_auth_configmap               = true
  aws_auth_node_iam_role_arns_non_windows = [for ng in module.eks_managed_node_group : ng.iam_role_arn]
  aws_auth_roles                          = local.role_mappings
  aws_auth_users                          = local.user_mappings
}

module "eks_managed_node_group" {
  #checkov:skip=CKV_SECRET_6: False positive; the comment for CKV_AWS_79 is no secret.
  #checkov:skip=CKV_AWS_79: False positive, the module already sets `"http_tokens": "required"` as default, see https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/18.30.2/submodules/eks-managed-node-group
  #checkov:skip=CKV_AWS_111: False positive; the mentioned policy for the instances to allow tagging and assigning IPv6 addresses is fine.
  #checkov:skip=CKV2_AWS_5: Security group "module.eks.module.eks.aws_security_group.node" is referenced in other modules
  for_each = var.node_groups
  source   = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version  = "19.10.0"

  name          = "${var.cluster_name}-${each.key}"
  iam_role_name = "${var.cluster_name}-nodegroup-${each.key}"
  min_size      = each.value.min_size
  max_size      = each.value.max_size
  desired_size  = each.value.desired_size

  instance_types = each.value.instance_types
  capacity_type  = each.value.capacity_type
  block_device_mappings = {
    xvda = {
      device_name = "/dev/xvda"
      ebs = {
        volume_size           = each.value.volume_size
        volume_type           = "gp3"
        encrypted             = true
        kms_key_id            = aws_kms_key.ebs.arn
        delete_on_termination = true
      }
    }
  }

  labels = {
    nodegroup_name = each.key
  }
  update_config = {
    max_unavailable_percentage = 50 # or set `max_unavailable`
  }

  cluster_name                      = module.eks.cluster_name
  cluster_version                   = module.eks.cluster_version
  subnet_ids                        = var.private_subnet_ids
  cluster_primary_security_group_id = module.eks.cluster_primary_security_group_id
  vpc_security_group_ids = [
    module.eks.cluster_security_group_id,
    module.eks.node_security_group_id
  ]
  taints = each.value.taints
}

# setting this tag is required for cluster autoscaler to work properly
# see https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/FAQ.md#how-can-i-scale-a-node-group-to-0
resource "aws_autoscaling_group_tag" "autoscaler_asg_tag" {
  count                  = length(local.asg_tags)
  autoscaling_group_name = local.asg_tags[count.index].asg_name
  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/nodegroup_name"
    value               = local.asg_tags[count.index].tag_value
    propagate_at_launch = true
  }
}

resource "aws_iam_role_policy_attachment" "SSMforSessionManager" {
  count      = length(local.node_group_iam_roles)
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  role       = local.node_group_iam_roles[count.index]
}

resource "null_resource" "enable_cloudwatch_metrics_autoscaling" {
  count = length(var.node_groups)

  provisioner "local-exec" {
    command     = "aws autoscaling enable-metrics-collection --region ${var.region} --granularity \"1Minute\" --auto-scaling-group-name  ${compact(flatten([for group in module.eks_managed_node_group : group.node_group_autoscaling_group_names]))[count.index]}"
    interpreter = ["bash", "-c"]
  }
  depends_on = [
    module.eks_managed_node_group
  ]
}
