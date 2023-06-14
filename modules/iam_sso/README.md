This module is meant to be used with the [IAM Identity Center](https://aws.amazon.com/iam/identity-center/). The module is built to manage Users and Groups with the Identity Center included users and groups. If you want to user Active Directory Users and Groups or any other external identity provider you should check for a different module.

# Basic usage

```hcl
module "iam_sso" {
  source          = "makandra/modules/aws//modules/iam_sso"
  # version = "0.6.0" please check which version you want to use

  permission_sets = [
    {
      name = "AdministratorAccess"
      description = "Allow Full Access to the account"
      policy_attachments = ["arn:aws:iam::aws:policy/AdministratorAccess"]
    },
  ]

  groups = {
    "GlobalAdministrators" = {
      description = "Members of this group are administrators for all accounts in the organization."
      account_assignments = [
        {
          permission_set_name = "AdministratorAccess"
          account_number = "ALL"
        }
      ]
    }
  }

  users = {
    "bob.alice" = {
      name = {
        given_name = "Bob"
        family_name = "Alice"
      }
      email = "bob.alice@foobararara.com"
      group_memberships = ["GlobalAdministrators"]
    }
  }
}
```

## Parameters for groups and users explained

Both variables use maps. The `key` of the map entries will be the name of the group or user.

The most important part is the `account_assignments` which take a `permission_set_name` and an `account_number`. The `permission_set_name` must match a managed permission set in the `permission_sets` variable.

For the `groups` you can set `account_number` to `ALL`. The given group with the permission set will then be assigned to all accounts in the organization. This feature is currently only supported for `groups`.

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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_permission_sets"></a> [permission\_sets](#module\_permission\_sets) | cloudposse/sso/aws//modules/permission-sets | 0.7.1 |

## Resources

| Name | Type |
|------|------|
| [aws_identitystore_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/identitystore_group) | resource |
| [aws_identitystore_group_membership.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/identitystore_group_membership) | resource |
| [aws_identitystore_user.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/identitystore_user) | resource |
| [aws_ssoadmin_account_assignment.groups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_account_assignment) | resource |
| [aws_ssoadmin_account_assignment.groups_all_accounts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_account_assignment) | resource |
| [aws_ssoadmin_account_assignment.users](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_account_assignment) | resource |
| [aws_organizations_organization.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |
| [aws_ssoadmin_instances.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssoadmin_instances) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_groups"></a> [groups](#input\_groups) | Map of groups to create in the identity store. | <pre>map(object({<br>    description = string<br>    account_assignments = optional(list(object({<br>      permission_set_name = string<br>      account_number      = string<br>    })))<br>  }))</pre> | `{}` | no |
| <a name="input_permission_sets"></a> [permission\_sets](#input\_permission\_sets) | Map of permission sets to create in the identity store. | <pre>list(object({<br>    name                = string<br>    description         = string<br>    policy_attachments  = optional(list(string), [])<br>    managed_policy_arns = optional(list(string))<br>    inline_policy       = optional(string, "")<br>    relay_state         = optional(string, "")<br>    session_duration    = optional(string, "")<br>    tags                = optional(map(string), {})<br>    customer_managed_policy_attachments = optional(list(object({<br>      name = string<br>      path = optional(string, "/")<br>    })), [])<br>  }))</pre> | `[]` | no |
| <a name="input_users"></a> [users](#input\_users) | Map of users to create in the identity store. | <pre>map(object({<br>    name = object({<br>      given_name  = string<br>      family_name = string<br>    })<br>    email             = string<br>    group_memberships = optional(list(string))<br>    account_assignments = optional(list(object({<br>      permission_set_name = string<br>      account_number      = string<br>    })))<br>  }))</pre> | `{}` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
