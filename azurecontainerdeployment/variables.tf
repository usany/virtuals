variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "acr_name" {
  description = "Name of Azure Container Registry (must be globally unique)"
  type        = string
}

variable "acr_sku" {
  description = "SKU for Container Registry"
  type        = string
  default     = "Basic"
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.acr_sku)
    error_message = "ACR SKU must be Basic, Standard, or Premium."
  }
}

variable "container_instances" {
  description = "Map of container instances to create"
  type = map(object({
    image             = string
    cpu               = number
    memory            = number
    environment_vars  = optional(map(string), {})
    ports             = optional(list(number), [80])
  }))
  default = {}
}

variable "enable_public_ip" {
  description = "Enable public IP for container instances"
  type        = bool
  default     = true
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
