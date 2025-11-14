terraform {
  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "aws" {
  region = "us-east-1" # Billing metrics are only available in us-east-1
}

module "cloudwatch_billing_alarm" {
  source              = "./cloudwatch"
  alert_emails        = var.alert_emails
  hardcap_threshold   = var.hardcap_threshold
  forecast_threshold  = var.forecast_threshold
}
