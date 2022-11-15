resource "aws_budgets_budget" "account_monthly" {
  count        = var.monthly_budget == 0 ? 0 : 1
  name         = "monthly account costs"
  budget_type  = "COST"
  limit_amount = var.monthly_budget
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = var.monthly_threshold
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = var.alarm_mail_recipients
  }
}

resource "aws_budgets_budget" "account_daily" {
  count        = var.daily_budget == 0 ? 0 : 1
  name         = "daily account costs"
  budget_type  = "COST"
  limit_amount = var.daily_budget
  limit_unit   = "USD"
  time_unit    = "DAILY"

  # exclude taxes on daily costs otherwise the first of a month  will likely trigger an alarm
  cost_types {
    include_tax = false
  }

  notification {
    comparison_operator        = "EQUAL_TO"
    threshold                  = var.daily_threshold
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = var.alarm_mail_recipients
  }
}
