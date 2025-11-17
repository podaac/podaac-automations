# AWS CloudWatch Billing Alarm Terraform

resource "aws_sns_topic" "billing_alerts" {
  name = "billing-alerts-topic"
}

resource "aws_sns_topic_subscription" "email" {
  count     = length(var.alert_emails)
  topic_arn = aws_sns_topic.billing_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_emails[count.index]
}

resource "aws_cloudwatch_metric_alarm" "billing_alarm" {
  alarm_name          = "billing-alarm-${var.hardcap_threshold}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = "21600" # 6 hours
  statistic           = "Maximum"
  threshold           = var.hardcap_threshold
  alarm_description   = "Alarm when AWS estimated charges exceed $${var.hardcap_threshold}"
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.billing_alerts.arn]
  ok_actions          = [aws_sns_topic.billing_alerts.arn]
  dimensions = {
    Currency = "USD"
  }
}

resource "aws_cloudwatch_metric_alarm" "forecast_billing_alarm" {
  alarm_name          = "forecast-billing-alarm-${var.forecast_threshold}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ForecastedCharges"
  namespace           = "AWS/Billing"
  period              = "21600" # 6 hours
  statistic           = "Maximum"
  threshold           = var.forecast_threshold
  alarm_description   = "Alarm when AWS forecasted charges exceed $${var.forecast_threshold}"
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.billing_alerts.arn]
  ok_actions          = [aws_sns_topic.billing_alerts.arn]
  dimensions = {
    Currency = "USD"
  }
}

resource "aws_ce_anomaly_subscription" "billing_anomaly_subscription" {
  name = "billing-anomaly-subscription"
  frequency = "IMMEDIATE"
  monitor_arn_list = [aws_ce_anomaly_monitor.billing_anomaly_monitor.arn]
  dynamic "subscriber" {
    for_each = var.alert_emails
    content {
      type    = "EMAIL"
      address = subscriber.value
    }
  }
}

resource "aws_ce_anomaly_monitor" "billing_anomaly_monitor" {
  name = "billing-anomaly-monitor"
  monitor_type = "DIMENSIONAL"
  monitor_dimension = "SERVICE"
}

# Note: To enable billing metrics, you must enable them in the AWS Console under Billing Preferences.
# Replace YOUR_EMAIL@example.com with your actual email address.
