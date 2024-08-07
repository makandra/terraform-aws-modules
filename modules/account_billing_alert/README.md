Module configures a monthly budget, a daily budget and cost anomaly detection. On a service level.

The module is intended to be used in a subaccount, not in a root account which should monitor the costs of multiple accounts.
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.51.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.51.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_budgets_budget.account_daily](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/budgets_budget) | resource |
| [aws_budgets_budget.account_monthly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/budgets_budget) | resource |
| [aws_ce_anomaly_monitor.service_monitor](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ce_anomaly_monitor) | resource |
| [aws_ce_anomaly_subscription.service_monitor_subscritpion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ce_anomaly_subscription) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarm_mail_recipients"></a> [alarm\_mail\_recipients](#input\_alarm\_mail\_recipients) | A list of e-mail recipients who receive an email when one of the thresholds is reached. | `list(string)` | n/a | yes |
| <a name="input_anomaly_detection_threshold"></a> [anomaly\_detection\_threshold](#input\_anomaly\_detection\_threshold) | The anomaly detection threshold in USD. If the costs vary that much from usual costs in the pasts a notification is sent. Setting to 0 disables anomaly detection. | `number` | n/a | yes |
| <a name="input_daily_budget"></a> [daily\_budget](#input\_daily\_budget) | This is the daily budget for the costs of the whole account in USD. Setting to 0 disables the budget. | `number` | n/a | yes |
| <a name="input_daily_threshold"></a> [daily\_threshold](#input\_daily\_threshold) | An alarm will be sent if the actual costs for the day are more than x% of the budget. This variable sets x. | `number` | `99` | no |
| <a name="input_monthly_budget"></a> [monthly\_budget](#input\_monthly\_budget) | This is the monthly budget for the costs of the whole account in USD. Setting to 0 disables the budget. | `number` | n/a | yes |
| <a name="input_monthly_threshold"></a> [monthly\_threshold](#input\_monthly\_threshold) | An alarm will be sent if forecasted costs for the month are more than x% of the budget. This variable sets x. | `number` | `80` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
