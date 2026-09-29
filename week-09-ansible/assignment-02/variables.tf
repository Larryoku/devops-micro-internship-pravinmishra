variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
  default     = "dmi-week09-rg"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
  default     = 4
}

variable "vm_size" {
  description = "Azure VM size"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Admin username for VMs"
  type        = string
  default     = "azureuser"
}

variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "dmi-cohort3"
}
