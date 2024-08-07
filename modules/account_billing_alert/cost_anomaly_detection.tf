resource "aws_ce_anomaly_monitor" "service_monitor" {
  count             = var.anomaly_detection_threshold == 0 ? 0 : 1
  name              = "CostsPerService"
  monitor_type      = "DIMENSIONAL"
  monitor_dimension = "SERVICE"
}

resource "aws_ce_anomaly_subscription" "service_monitor_subscritpion" {
  count     = var.anomaly_detection_threshold == 0 ? 0 : 1
  name      = "DAILYSUBSCRIPTION"
  frequency = "DAILY"

  threshold_expression {
    dimension {
      key           = "ANOMALY_TOTAL_IMPACT_ABSOLUTE"
      match_options = ["GREATER_THAN_OR_EQUAL"]
      values        = [var.anomaly_detection_threshold]
    }
  }

  monitor_arn_list = [
    aws_ce_anomaly_monitor.service_monitor[0].arn,
  ]

  dynamic "subscriber" {
    for_each = var.alarm_mail_recipients
    content {
      type    = "EMAIL"
      address = subscriber.value
    }
  }
}
