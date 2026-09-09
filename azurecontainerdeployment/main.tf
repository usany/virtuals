data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  sku                 = var.acr_sku
  admin_enabled       = true

  tags = merge(
    var.common_tags,
    {
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  )
}

resource "azurerm_container_group" "containers" {
  for_each = var.container_instances

  name                = "${each.key}-${var.environment}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  os_type             = "Linux"
  ip_address_type     = var.enable_public_ip ? "Public" : "Private"
  dns_name_label      = var.enable_public_ip ? "${each.key}-${var.environment}" : null

  container {
    name   = each.key
    image  = each.value.image
    cpu    = each.value.cpu
    memory = each.value.memory

    dynamic "ports" {
      for_each = each.value.ports
      content {
        port     = ports.value
        protocol = "TCP"
      }
    }

    environment_variables = each.value.environment_vars
  }

  tags = merge(
    var.common_tags,
    {
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  )
}
