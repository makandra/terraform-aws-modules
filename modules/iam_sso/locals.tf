locals {
  # we rely on terraforms grouping mode to pass list contents as arguments to the merge function.
  # see https://makandracards.com/operations/541333-use-terraform-grouping-mode-like-golang-s-ellipsis-expression

  # build a map of all group memberships for the users.
  group_memberships = merge([
    for user, user_config in var.users : {
      for group in user_config.group_memberships :
      "${user}_${group}" => {
        user_id  = aws_identitystore_user.this[user].user_id
        group_id = aws_identitystore_group.this[group].group_id
      }
    } if user_config.group_memberships != null
  ]...)

  # build a map of all groups to assign to the given accounts
  group_assignments = merge([
    for group, group_config in var.groups : {
      for assignment in group_config.account_assignments :
      "${group}_${assignment.account_number}" => {
        group_id           = aws_identitystore_group.this[group].group_id
        permission_set_arn = module.permission_sets.permission_sets[assignment.permission_set_name].arn
        account_number     = assignment.account_number
      } if assignment != null && assignment.account_number != "ALL"
    } if group_config.account_assignments != null
  ]...)

  # build a list of all group assignemnts and permission sets which should be assigned to all accounts in the organization
  groups_to_assign_to_all_accounts = flatten([
    for group, group_config in var.groups : [
      for assignment in group_config.account_assignments : {
        group_name         = group
        group_id           = aws_identitystore_group.this[group].group_id
        permission_set_arn = module.permission_sets.permission_sets[assignment.permission_set_name].arn
      } if assignment != null && assignment.account_number == "ALL"
    ] if group_config.account_assignments != null
  ])

  # for the group assignments to all accounts we create a map of the combinations of group/permissionset and account IDs of active accounts
  list_of_active_account_ids                = [for account in data.aws_organizations_organization.this.accounts : account.id if account.status == "ACTIVE"]
  all_account_groups_account_id_assocations = length(local.groups_to_assign_to_all_accounts) > 0 ? setproduct(local.groups_to_assign_to_all_accounts, local.list_of_active_account_ids) : []

  # lastly we create a map of all group assignments to all accounts with the key being the group name and account ID
  # This way we can use a for_each instead of count
  group_all_account_assignments = {
    for group in local.all_account_groups_account_id_assocations : "${group[0].group_name}_${group[1]}" => {
      group_id           = group[0].group_id
      permission_set_arn = group[0].permission_set_arn
      account_number     = group[1]
    }
  }

  # build a map of all user assignments to the given accounts
  user_assignments = merge([
    for user, user_config in var.users : {
      for assignment in user_config.account_assignments :
      "${user}_${assignment.account_number}" => {
        user_id            = aws_identitystore_user.this[user].user_id
        permission_set_arn = module.permission_sets.permission_sets[assignment.permission_set_name].arn
        account_number     = assignment.account_number
      } if assignment != null && assignment.account_number != "ALL"
    } if user_config.account_assignments != null
  ]...)
}
