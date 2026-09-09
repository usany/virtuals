# Azure Container Deployment - Infrastructure as Code

Terraform configuration for deploying containerized applications on Azure using:
- **Azure Container Registry (ACR)** - Private container image registry
- **Azure Container Instances (ACI)** - Serverless container hosting

## Prerequisites

1. Azure subscription
2. [Terraform](https://www.terraform.io/downloads) >= 1.0
3. [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

## Setup

### 1. Authenticate with Azure

```bash
az login
```

### 2. Create a Resource Group (if not exists)

```bash
az group create --name my-resource-group --location eastus
```

### 3. Configure Variables

Copy and customize the example file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your values:
- `resource_group_name` - Your Azure resource group
- `acr_name` - Unique name for your container registry (alphanumeric only)
- `environment` - Environment name (dev, staging, prod)
- `container_instances` - Define your containers

## Deployment

### Initialize Terraform

```bash
terraform init
```

### Plan Deployment

```bash
terraform plan
```

### Apply Configuration

```bash
terraform apply
```

### Destroy Resources

```bash
terraform destroy
```

## Usage Examples

### Example 1: Simple Nginx Container

```hcl
container_instances = {
  web = {
    image   = "nginx:latest"
    cpu     = 0.5
    memory  = 1.0
    ports   = [80]
  }
}
```

### Example 2: Push Image to ACR

```bash
# Login to your ACR
az acr login --name myacr

# Tag your local image
docker tag myimage:latest myacr.azurecr.io/myimage:latest

# Push to ACR
docker push myacr.azurecr.io/myimage:latest
```

### Example 3: Multiple Containers

```hcl
container_instances = {
  frontend = {
    image  = "myacr.azurecr.io/frontend:latest"
    cpu    = 0.5
    memory = 1.0
    ports  = [3000]
  }
  backend = {
    image  = "myacr.azurecr.io/backend:latest"
    cpu    = 1.0
    memory = 2.0
    ports  = [8080]
    environment_vars = {
      DATABASE_URL = "postgresql://..."
      API_KEY      = "secret-key"
    }
  }
}
```

## Outputs

After deployment, retrieve important information:

```bash
terraform output acr_login_server
terraform output container_fqdns
terraform output acr_admin_password  # (sensitive)
```

## File Structure

- `provider.tf` - Azure provider configuration
- `main.tf` - ACR and Container Instance resources
- `variables.tf` - Input variables and validations
- `outputs.tf` - Output values
- `terraform.tfvars.example` - Example configuration
- `README.md` - This documentation

## Best Practices

1. **Never commit `terraform.tfvars`** - Use `.gitignore`
2. **Store state remotely** - Configure Azure Storage for Terraform state
3. **Use environment variables** - For sensitive values: `TF_VAR_*`
4. **Tag resources** - Use `common_tags` for organization
5. **Separate by environment** - Use different `.tfvars` files per environment

## Remote State Configuration

Store Terraform state in Azure Storage:

```bash
# Create storage account
az storage account create \
  --name tfstate$(date +%s) \
  --resource-group my-rg \
  --location eastus

# Create blob container
az storage container create \
  --name tfstate \
  --account-name <storage-account-name>
```

Add to `provider.tf`:

```hcl
backend "azurerm" {
  resource_group_name  = "my-rg"
  storage_account_name = "tfstate..."
  container_name       = "tfstate"
  key                  = "prod.terraform.tfstate"
}
```

## Troubleshooting

### ACR Name Already Exists
ACR names must be globally unique. Add a suffix:
```hcl
acr_name = "myacr${random_string.suffix.result}"
```

### Container Won't Start
Check logs:
```bash
az container logs --resource-group my-rg --name container-name
```

### Authentication Errors
Refresh Azure CLI token:
```bash
az logout
az login
```

## Support

For more information:
- [Azure Container Registry Documentation](https://docs.microsoft.com/en-us/azure/container-registry/)
- [Azure Container Instances Documentation](https://docs.microsoft.com/en-us/azure/container-instances/)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
