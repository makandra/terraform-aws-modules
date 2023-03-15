Module configures basic components for EKS. Wrapping the [AWS EKS Terraform module](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest).

See the example section to see how the module can be used.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.6 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.5 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.6 |
| <a name="provider_null"></a> [null](#provider\_null) | >= 3.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | 19.10.0 |
| <a name="module_eks_managed_node_group"></a> [eks\_managed\_node\_group](#module\_eks\_managed\_node\_group) | terraform-aws-modules/eks/aws//modules/eks-managed-node-group | 19.10.0 |

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group_tag.autoscaler_asg_tag](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group_tag) | resource |
| [aws_iam_role_policy_attachment.SSMforSessionManager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.eks_ebs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.eks_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.eks_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.ebs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.eks_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [null_resource.enable_cloudwatch_metrics_autoscaling](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.ensure_role_exists](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.eks_ebs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.eks_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_enabled_log_types"></a> [cluster\_enabled\_log\_types](#input\_cluster\_enabled\_log\_types) | A list of the desired control plane logs to enable. | `list(string)` | <pre>[<br>  "audit",<br>  "api",<br>  "authenticator",<br>  "scheduler",<br>  "controllerManager"<br>]</pre> | no |
| <a name="input_cluster_endpoint_public_access"></a> [cluster\_endpoint\_public\_access](#input\_cluster\_endpoint\_public\_access) | Whether or not to enable public access to the cluster endpoint. | `bool` | `false` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster. | `string` | n/a | yes |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | EKS version to use. See https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html | `string` | n/a | yes |
| <a name="input_iam_role_rbac_mappings"></a> [iam\_role\_rbac\_mappings](#input\_iam\_role\_rbac\_mappings) | A map of IAM role names to map to Kubernetes RBAC roles. The key is the IAM role name, the value is is a list of the Kubernetes RBAC role names. | `map(list(string))` | `{}` | no |
| <a name="input_iam_user_rbac_mappings"></a> [iam\_user\_rbac\_mappings](#input\_iam\_user\_rbac\_mappings) | A map of IAM user names to map to Kubernetes RBAC roles. The key is the IAM user name, the value is is a list of the Kubernetes RBAC role names. | `map(list(string))` | `{}` | no |
| <a name="input_node_groups"></a> [node\_groups](#input\_node\_groups) | Node group definitions for the EKS cluster. | <pre>map(object({<br>    min_size       = number<br>    max_size       = number<br>    desired_size   = number<br>    volume_size    = number<br>    capacity_type  = string<br>    instance_types = list(string)<br>    taints         = optional(any, [])<br>  }))</pre> | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | The private subnet IDs EKS nodes are attached to. | `list(string)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region where ressources should be managed. | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID EKS will be attached to. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#output\_cluster\_certificate\_authority\_data) | base64 encoded EKS Certificate Authority Data |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | The cluster endpoint to communicate with the cluster. |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The EKS cluster ID. |
| <a name="output_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#output\_cluster\_oidc\_issuer\_url) | The OIDC issuer URL. |
| <a name="output_node_security_group_id"></a> [node\_security\_group\_id](#output\_node\_security\_group\_id) | ID of the node shared security group. |
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn) | The OIDC provider ARN. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
