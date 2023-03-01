module "iam_sso" {
  source = "../.."

  permission_sets = [
    {
      name               = "AdministratorAccess"
      description        = "Allow Full Access to the account"
      policy_attachments = ["arn:aws:iam::aws:policy/AdministratorAccess"]
    },
  ]

  groups = {
    "GlobalAdministrators" = {
      description = "Members of this group are administrators for all accounts in the organization."
      account_assignments = [
        {
          permission_set_name = "AdministratorAccess"
          account_number      = "ALL"
        }
      ]
    }
  }

  users = {
    "bob.alice" = {
      name = {
        given_name  = "Bob"
        family_name = "Alice"
      }
      email             = "bob.alice@foobararara.com"
      group_memberships = ["GlobalAdministrators"]
    }
  }
}
