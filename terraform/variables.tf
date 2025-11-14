variable "alert_emails" {
  description = "List of emails to notify for billing alerts."
  type        = list(string)
}

variable "hardcap_threshold" {
  description = "Threshold for the hardcap billing alarm (USD)"
  type        = number
}

variable "forecast_threshold" {
  description = "Threshold for the forecast billing alarm (USD)"
  type        = number
}
