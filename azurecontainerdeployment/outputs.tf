output "resource_group_name" {
  description = "Name of the resource group"
  value       = data.azurerm_resource_group.rg.name
}

output "acr_name" {
  description = "Name of the Azure Container Registry"
  value       = azurerm_container_registry.acr.name
}

output "acr_login_server" {
  description = "Login server URL for ACR"
  value       = azurerm_container_registry.acr.login_server
}

output "acr_admin_username" {
  description = "Admin username for ACR"
  value       = azurerm_container_registry.acr.admin_username
  sensitive   = true
}

output "acr_admin_password" {
  description = "Admin password for ACR"
  value       = azurerm_container_registry.acr.admin_password
  sensitive   = true
}

output "container_groups" {
  description = "Details of created container groups"
  value = {
    for name, group in azurerm_container_group.containers : name => {
      id              = group.id
      fqdn            = group.fqdn
      ip_address      = group.ip_address
      restart_policy  = group.restart_policy
    }
  }
}

output "container_fqdns" {
  description = "FQDNs of container instances"
  value = {
    for name, group in azurerm_container_group.containers : name => group.fqdn
  }
}
