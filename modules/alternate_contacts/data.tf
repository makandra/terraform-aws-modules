data "aws_organizations_organization" "this" {
  count = var.assign_contacts_to_all_accounts ? 1 : 0
}
