This module enables cloudtrail and creates an S3 bucket for it. No other configuration is possible and it's not set for multi-account setup. There are other modules to enable this configuration.

For examples please look in the `tests` directory.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.7.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_s3-bucket"></a> [s3-bucket](#module\_s3-bucket) | terraform-aws-modules/s3-bucket/aws | 3.0.1 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudtrail.this](https://registry.terraform.io/providers/hashicorp/aws/4.7.0/docs/resources/cloudtrail) | resource |
| [aws_iam_policy_document.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/4.7.0/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/4.7.0/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_component"></a> [component](#input\_component) | The component to which the resources deployed in this module belong to. This can be an application or a part of the overall infrastructure. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment (test, prod, infra) for the resources created in this module. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS region to which the VPC will be deployed. | `string` | `"eu-central-1"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
