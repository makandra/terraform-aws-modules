data "aws_organizations_organization" "this" {
  count = var.assign_contacts_to_all_accounts ? 1 : 0
}

locals {
  operations_contact = merge(var.default_alternate_contact, var.operations_contact)
  billing_contact    = merge(var.default_alternate_contact, var.billing_contact)
  security_contact   = merge(var.default_alternate_contact, var.security_contact)

  list_of_active_account_ids = var.assign_contacts_to_all_accounts ? [for account in data.aws_organizations_organization.this[0].non_master_accounts : account.id if account.status == "ACTIVE"] : null

  account_list = var.assign_contacts_to_all_accounts ? setsubtract(local.list_of_active_account_ids, var.filter_accounts) : []
}

resource "aws_account_alternate_contact" "operations" {
  alternate_contact_type = "OPERATIONS"

  name          = local.operations_contact["name"]
  title         = local.operations_contact["title"]
  email_address = local.operations_contact["email_address"]
  phone_number  = local.operations_contact["phone_number"]
}

resource "aws_account_alternate_contact" "billing" {
  alternate_contact_type = "BILLING"

  name          = local.billing_contact["name"]
  title         = local.billing_contact["title"]
  email_address = local.billing_contact["email_address"]
  phone_number  = local.billing_contact["phone_number"]
}

resource "aws_account_alternate_contact" "security" {
  alternate_contact_type = "SECURITY"

  name          = local.security_contact["name"]
  title         = local.security_contact["title"]
  email_address = local.security_contact["email_address"]
  phone_number  = local.security_contact["phone_number"]
}


resource "aws_account_alternate_contact" "operations_member_account" {
  for_each = toset(local.account_list)

  alternate_contact_type = "OPERATIONS"

  account_id    = each.key
  name          = local.operations_contact["name"]
  title         = local.operations_contact["title"]
  email_address = local.operations_contact["email_address"]
  phone_number  = local.operations_contact["phone_number"]
}

resource "aws_account_alternate_contact" "billing_member_account" {
  for_each = toset(local.account_list)

  alternate_contact_type = "BILLING"

  account_id    = each.key
  name          = local.billing_contact["name"]
  title         = local.billing_contact["title"]
  email_address = local.billing_contact["email_address"]
  phone_number  = local.billing_contact["phone_number"]
}

resource "aws_account_alternate_contact" "security_member_account" {
  for_each = toset(local.account_list)

  alternate_contact_type = "SECURITY"

  account_id    = each.key
  name          = local.security_contact["name"]
  title         = local.security_contact["title"]
  email_address = local.security_contact["email_address"]
  phone_number  = local.security_contact["phone_number"]
}
