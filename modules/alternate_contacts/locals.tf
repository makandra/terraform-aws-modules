locals {
  operations_contact = var.operations_contact != null ? var.operations_contact : var.default_alternate_contact
  billing_contact    = var.billing_contact != null ? var.billing_contact : var.default_alternate_contact
  security_contact   = var.security_contact != null ? var.security_contact : var.default_alternate_contact

  list_of_active_account_ids = var.assign_contacts_to_all_accounts ? [for account in data.aws_organizations_organization.this[0].non_master_accounts : account.id if account.status == "ACTIVE"] : null

  account_list = var.assign_contacts_to_all_accounts ? setsubtract(local.list_of_active_account_ids, var.filter_accounts) : []
}
