variable "location" {
  type        = string
  description = "Resource location for Azure resources."
  default     = "uksouth"
}

variable "location_short" {
  type        = string
  description = "Short Azure region token for resource naming."
  default     = "uks"
}

variable "environment" {
  type        = string
  description = "Name of Azure environment."
}

variable "workload" {
  type        = string
  description = "Workload short name for resource naming."
  default     = "certwatch"
}

variable "instance" {
  type        = string
  description = "Instance number for resource naming."
  default     = "01"
}

variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare API token for DNS management."
  sensitive   = true
}

variable "cloudflare_account_id" {
  type        = string
  description = "Cloudflare account ID."
}

variable "brevo_api_key" {
  type        = string
  description = "Brevo API key for transactional email."
  sensitive   = true
}

variable "email_from" {
  type        = string
  description = "Verified Brevo sender email address for outbound email."
}

variable "email_from_name" {
  type        = string
  description = "Display name for outbound email."
  default     = "CertWatch"
}

variable "email_reply_to" {
  type        = string
  description = "Reply-to address for outbound email. Empty disables reply-to."
  default     = ""
}
