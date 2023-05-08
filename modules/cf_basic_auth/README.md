Module to create a [cloudfront function](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/cloudfront-functions.html) which can be used to add basic authentication to a cloudfront distribution.

The created function can be referenced in a cloudfront distribution.

Example:
```hcl

module "cf_function_basic_auth" {
  source   = "github.com/makandra/terraform-aws-modules//modules/cf_basic_auth?version=$VERSION"

  basic_auth = $LIST_OF_BASE64_ENCODED_BASIC_AUTH_STRINGS
  name       = $FUNCTION_NAME
}

resource "aws_cloudfront_distribution" "example" {
  # ... other configuration ...

  # function_association is also supported by default_cache_behavior
  ordered_cache_behavior {
    # ... other configuration ...

    function_association {
      event_type   = "viewer-request"
      function_arn = module.cf_function_basic_auth.arn # ARN of the created basic auth cloudfront function
    }
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.50.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.50.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_function) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_basic_auth"></a> [basic\_auth](#input\_basic\_auth) | List of base64 encoded credentials for Basic Auth | `list(string)` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the Cloud Front Function | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the created Basic Auth CloudFront Function |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
