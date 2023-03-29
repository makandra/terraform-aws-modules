locals {
  operations_contact = merge(var.default_alternate_contact, var.operations_contact)
  billing_contact    = merge(var.default_alternate_contact, var.billing_contact)
  security_contact   = merge(var.default_alternate_contact, var.security_contact)

  list_of_active_account_ids = var.assign_contacts_to_all_accounts ? [for account in data.aws_organizations_organization.this[0].non_master_accounts : account.id if account.status == "ACTIVE"] : null

  account_list = var.assign_contacts_to_all_accounts ? setsubtract(local.list_of_active_account_ids, var.filter_accounts) : []
}
