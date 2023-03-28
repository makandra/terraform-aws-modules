data "aws_ssoadmin_instances" "this" {}
data "aws_organizations_organization" "this" {}

module "permission_sets" {
  source  = "cloudposse/sso/aws//modules/permission-sets"
  version = "0.7.1"

  permission_sets = var.permission_sets
}

resource "aws_identitystore_group" "this" {
  for_each          = var.groups
  display_name      = each.key
  description       = each.value.description
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
}

resource "aws_identitystore_user" "this" {
  for_each          = var.users
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]

  display_name = "${each.value.name.given_name} ${each.value.name.family_name}"
  user_name    = each.key

  name {
    given_name  = each.value.name.given_name
    family_name = each.value.name.family_name
  }

  emails {
    value = each.value.email
  }
}

resource "aws_identitystore_group_membership" "this" {
  for_each          = local.group_memberships
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  group_id          = each.value.group_id
  member_id         = each.value.user_id
}

resource "aws_ssoadmin_account_assignment" "groups" {
  for_each     = local.group_assignments
  instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]

  permission_set_arn = each.value.permission_set_arn

  principal_id   = each.value.group_id
  principal_type = "GROUP"

  target_id   = each.value.account_number
  target_type = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "groups_all_accounts" {
  for_each     = local.group_all_account_assignments
  instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]

  permission_set_arn = each.value.permission_set_arn

  principal_id   = each.value.group_id
  principal_type = "GROUP"

  target_id   = each.value.account_number
  target_type = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "users" {
  for_each     = local.user_assignments
  instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]

  permission_set_arn = each.value.permission_set_arn

  principal_id   = each.value.user_id
  principal_type = "USER"

  target_id   = each.value.account_number
  target_type = "AWS_ACCOUNT"
}
