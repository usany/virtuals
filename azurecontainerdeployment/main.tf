data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

<<<<<<< HEAD
=======
data "azurerm_container_registry" "remake" {
  name                = "remake"
  resource_group_name = "DefaultResourceGroup-SE"
}

>>>>>>> main
resource "random_string" "dns_suffix" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_container_registry" "acr" {
  name                = "remakeacr1001"
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
  dns_name_label      = var.enable_public_ip ? "${each.key}-${var.environment}-${random_string.dns_suffix.result}" : null
<<<<<<< HEAD
=======

  image_registry_credential {
    server   = data.azurerm_container_registry.remake.login_server
    username = data.azurerm_container_registry.remake.admin_username
    password = data.azurerm_container_registry.remake.admin_password
  }
>>>>>>> main

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
