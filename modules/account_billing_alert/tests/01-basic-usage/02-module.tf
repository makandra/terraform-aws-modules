module "billing" {
  source = "../.."

  monthly_budget              = 1000
  daily_budget                = 100
  anomaly_detection_threshold = 100
  alarm_mail_recipients       = ["foo@bar.barfoo"]
}
