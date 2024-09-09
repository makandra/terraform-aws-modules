This module enables cloudtrail and creates an S3 bucket for it. No other configuration is possible and it's not set for multi-account setup. There are other modules to enable this configuration.

For examples please look in the `tests` directory.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.4.9 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.4.9 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_kms"></a> [kms](#module\_kms) | terraform-aws-modules/kms/aws | 3.1.0 |
| <a name="module_s3-bucket"></a> [s3-bucket](#module\_s3-bucket) | terraform-aws-modules/s3-bucket/aws | 4.1.2 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudtrail.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudtrail_name"></a> [cloudtrail\_name](#input\_cloudtrail\_name) | The name of the cloudtrail. This is optional and defaults to cloudtrail-<ACCOUNTID>. | `string` | `null` | no |
| <a name="input_create_kms_key"></a> [create\_kms\_key](#input\_create\_kms\_key) | Controls if a customer managed KMS key should be created | `bool` | `true` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN of the KMS key to use for encryption of cloudtrail. If no ARN is provided and create\_kms\_key is not used cloudtrail won't be encrypted. | `string` | `null` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | The name of the S3 bucket to store cloudtrail logs in. This is optional and defaults to a prefix with cloudtrail-<ACCOUNTID>-. | `string` | `null` | no |
| <a name="input_s3_lifecycle_expiration"></a> [s3\_lifecycle\_expiration](#input\_s3\_lifecycle\_expiration) | Days after which files get marked non-current from the expire lifecycle rule. | `number` | `365` | no |
| <a name="input_s3_lifecycle_noncurrent_expiration"></a> [s3\_lifecycle\_noncurrent\_expiration](#input\_s3\_lifecycle\_noncurrent\_expiration) | Days after which non-current marked files get deleted from the expire lifecycle rule. | `number` | `180` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
