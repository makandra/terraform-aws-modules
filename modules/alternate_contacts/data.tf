data "aws_organizations_organization" "this" {
  count = var.assign_contacts_to_all_accounts ? 1 : 0
}

data "aws_caller_identity" "current" {
  count = var.assign_contacts_to_all_accounts ? 0 : 1
}
