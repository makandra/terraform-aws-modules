locals {
  # build a list of all group memberships for the users.
  group_memberships = flatten([
    for user, user_config in var.users : [
      for group in user_config.group_memberships : {
        user_id  = aws_identitystore_user.this[user].user_id
        group_id = aws_identitystore_group.this[group].group_id
      }
    ] if user_config.group_memberships != null
  ])

  # build a list of all groups to assign to the given accounts
  group_assignments = flatten([
    for group, group_config in var.groups : [
      for assignment in group_config.account_assignments : {
        group_id           = aws_identitystore_group.this[group].group_id
        permission_set_arn = module.permission_sets.permission_sets[assignment.permission_set_name].arn
        account_number     = assignment.account_number
      } if assignment != null && assignment.account_number != "ALL"
    ] if group_config.account_assignments != null
  ])

  # build a list of all groups which should be assigned to all accounts in the organization
  groups_to_assign_to_all_accounts = flatten([
    for group, group_config in var.groups : [
      for assignment in group_config.account_assignments : {
        group_id           = aws_identitystore_group.this[group].group_id
        permission_set_arn = module.permission_sets.permission_sets[assignment.permission_set_name].arn
      } if assignment != null && assignment.account_number == "ALL"
    ] if group_config.account_assignments != null
  ])

  # for the group assignments to all accounts we create a list of the combinations of group/permissionset and account IDs of active accounts
  list_of_active_account_ids = [for account in data.aws_organizations_organization.this.accounts : account.id if account.status == "ACTIVE"]
  groups_for_all_accounts    = length(local.groups_to_assign_to_all_accounts) > 0 ? setproduct(local.groups_to_assign_to_all_accounts, local.list_of_active_account_ids) : []

  # build a list of all user assignments to the given accounts
  user_assignments = flatten([
    for user, user_config in var.users : [
      for assignment in user_config.account_assignments : {
        user_id            = aws_identitystore_user.this[user].user_id
        permission_set_arn = module.permission_sets.permission_sets[assignment.permission_set_name].arn
        account_number     = assignment.account_number
      } if assignment != null && assignment.account_number != "ALL"
    ] if user_config.account_assignments != null
  ])
}
