output "public_ip" {
  description = "Public IP address of the EpicBook VM"
  value       = azurerm_public_ip.main.ip_address
}

output "admin_user" {
  description = "Admin username for the VM"
  value       = var.admin_username
}

output "private_key_path" {
  description = "Path to the SSH private key"
  value       = local_file.ssh_key.filename
}

output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.main.name
}

output "vm_name" {
  description = "Name of the VM"
  value       = azurerm_linux_virtual_machine.main.name
}
