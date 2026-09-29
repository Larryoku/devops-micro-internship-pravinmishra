variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
  default     = "dmi-epicbook-prod-rg"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "vm_size" {
  description = "Azure VM size"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Admin username for VM"
  type        = string
  default     = "ubuntu"
}

variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "production"
}
