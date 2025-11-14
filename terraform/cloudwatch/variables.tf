variable "alert_emails" {
  description = "List of emails to notify for billing alerts."
  type        = list(string)
  default     = ["YOUR_EMAIL@example.com"] # <-- Replace with your emails
}

variable "hardcap_threshold" {
  description = "Threshold for the hardcap billing alarm (USD)"
  type        = number
  default     = 5500
}

variable "forecast_threshold" {
  description = "Threshold for the forecast billing alarm (USD)"
  type        = number
  default     = 7000
}
