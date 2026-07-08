# variables.tf — Input variables

variable "aws_region" {
  description = "Primary AWS region for regional resources (S3 bucket, etc.)."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Short project identifier used for naming and tagging resources."
  type        = string
  default     = "static-website"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "project_name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "domain_name" {
  description = "Fully qualified domain name for the site (e.g. www.example.com)."
  type        = string
}

variable "hosted_zone_id" {
  description = "Route 53 hosted zone ID for the domain."
  type        = string
}

variable "acm_certificate_arn" {
  description = "ARN of an existing ACM certificate in us-east-1. Leave empty to skip aliasing/HTTPS custom domain."
  type        = string
  default     = ""
}

variable "index_document" {
  description = "Default root object served by CloudFront/S3."
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "Document returned for error responses."
  type        = string
  default     = "error.html"
}

variable "price_class" {
  description = "CloudFront price class controlling edge location coverage."
  type        = string
  default     = "PriceClass_100"

  validation {
    condition     = contains(["PriceClass_100", "PriceClass_200", "PriceClass_All"], var.price_class)
    error_message = "price_class must be one of PriceClass_100, PriceClass_200, or PriceClass_All."
  }
}

variable "noncurrent_version_expiration_days" {
  description = "Number of days to retain non-current S3 object versions before expiring them."
  type        = number
  default     = 30

  validation {
    condition     = var.noncurrent_version_expiration_days > 0
    error_message = "noncurrent_version_expiration_days must be greater than 0."
  }
}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default = {
    Project   = "static-website"
    ManagedBy = "terraform"
  }
}
