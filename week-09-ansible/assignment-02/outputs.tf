output "public_ips" {
  description = "Public IP addresses of all four VMs"
  value = {
    web1 = azurerm_public_ip.main[0].ip_address
    web2 = azurerm_public_ip.main[1].ip_address
    app1 = azurerm_public_ip.main[2].ip_address
    db1  = azurerm_public_ip.main[3].ip_address
  }
}

output "private_key_path" {
  description = "Path to the SSH private key"
  value       = local_file.ssh_key.filename
}

output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.main.name
}

output "virtual_network_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}
