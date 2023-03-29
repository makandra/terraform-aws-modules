# alternate_contacts

It's recommended to set the alternate contacts for each AWS account. This module set's the alternate contact for `OPERATIONS`, `SECURITY` and `BILLING`. It's not optional to set them but you can provide one default value which is used for all of them.

```hcl
module "alternate_contacts" {
  source          = "makandra/modules/aws//modules/alternate_contacts"
  # version = "1.1.0" please check which version you want to use

  # if you're applying this in your organizations master account you can configure the same
  # contacts for all member accounts
  assign_contacts_to_all_accounts = true

  # if you want to omit some accounts from the list of the member accounts
  filter_accounts = [ "123456789" ]

  default_alternate_contact = {
    name          = "Bob"
    title         = "Bob the Admin"
    email_address = "bob@foobarus.xyz"
    phone_number  = "123455667"
  }

  billing_contact = {
    name          = "Steve"
    title         = "Steve the finance guy."
    email_address = "billing@foobarus.xyz"
    phone_number  = "12356234546"
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
| [aws_account_alternate_contact.billing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_alternate_contact) | resource |
| [aws_account_alternate_contact.billing_member_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_alternate_contact) | resource |
| [aws_account_alternate_contact.operations](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_alternate_contact) | resource |
| [aws_account_alternate_contact.operations_member_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_alternate_contact) | resource |
| [aws_account_alternate_contact.security](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_alternate_contact) | resource |
| [aws_account_alternate_contact.security_member_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_alternate_contact) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_organizations_organization.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assign_contacts_to_all_accounts"></a> [assign\_contacts\_to\_all\_accounts](#input\_assign\_contacts\_to\_all\_accounts) | If true, assign the alternate contacts to all accounts in the organization. | `bool` | `false` | no |
| <a name="input_billing_contact"></a> [billing\_contact](#input\_billing\_contact) | Contact data for the billing contact. | <pre>object({<br>    name          = string<br>    title         = string<br>    email_address = string<br>    phone_number  = string<br>  })</pre> | `null` | no |
| <a name="input_default_alternate_contact"></a> [default\_alternate\_contact](#input\_default\_alternate\_contact) | These defaults are used for all alternate contacts if no specifics are given. | <pre>object({<br>    name          = string<br>    title         = string<br>    email_address = string<br>    phone_number  = string<br>  })</pre> | n/a | yes |
| <a name="input_filter_accounts"></a> [filter\_accounts](#input\_filter\_accounts) | A list of account IDs to filter the list of accounts to assign alternate contacts to. This is only relevant if assign\_contacts\_to\_all\_accounts is true. | `list(string)` | `[]` | no |
| <a name="input_operations_contact"></a> [operations\_contact](#input\_operations\_contact) | Contact data for the operations contact. | <pre>object({<br>    name          = string<br>    title         = string<br>    email_address = string<br>    phone_number  = string<br>  })</pre> | `null` | no |
| <a name="input_security_contact"></a> [security\_contact](#input\_security\_contact) | Contact data for the security contact. | <pre>object({<br>    name          = string<br>    title         = string<br>    email_address = string<br>    phone_number  = string<br>  })</pre> | `null` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
