# OIDC GitLab

Configures [OpenID Connect in AWS to retrieve temporary credentials](https://docs.gitlab.com/ee/ci/cloud_services/aws/) for a GitLab instance.
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.55.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.55.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_openid_connect_provider.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gitlab_url"></a> [gitlab\_url](#input\_gitlab\_url) | URL of your gitlab instance. | `string` | `"https://gitlab.com"` | no |
| <a name="input_match_field"></a> [match\_field](#input\_match\_field) | Variable attribute for the condition block of the assume role policy. See the [GitLab documentation](https://docs.gitlab.com/ci/cloud_services/aws/#configure-a-role-and-trust) for possbile values | `string` | `"sub"` | no |
| <a name="input_match_value"></a> [match\_value](#input\_match\_value) | Value for the condition block of the assume role policy. See the [GitLab documentation](https://docs.gitlab.com/ci/cloud_services/aws/#configure-a-role-and-trust) for possbile values | `list(any)` | n/a | yes |
| <a name="input_policies"></a> [policies](#input\_policies) | List of policy ARNs to attach to the role | `set(string)` | <pre>[<br/>  "arn:aws:iam::aws:policy/ReadOnlyAccess"<br/>]</pre> | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Name of the created IAM role | `string` | `"Gitlab"` | no |
| <a name="input_thumbprint_list"></a> [thumbprint\_list](#input\_thumbprint\_list) | List of server certificate thumbprints for the OpenID Connect (OIDC) identity provider's server certificate(s). Required for AWS provider versions <5.81.0! See the [provider documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) for more information. | `set(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_gitlab_role_arn"></a> [gitlab\_role\_arn](#output\_gitlab\_role\_arn) | Role that needs to be assumed by GitLab CI. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
