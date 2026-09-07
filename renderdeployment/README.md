# Render Deployment with Terraform

This directory contains Terraform configuration for deploying applications to Render, similar to the Vercel deployment setup.

## Prerequisites

1. **Terraform** installed (v1.0+)
2. **Render account** with API access
3. **GitHub repository** connected to your Render account

## Setup Instructions

### 1. Get Render API Key

- Log in to [Render Dashboard](https://dashboard.render.com)
- Go to Account Settings → API Keys
- Create a new API key and save it securely

### 2. Get Owner ID

- Your owner ID can be found in the Render dashboard URL or API documentation
- It's typically a unique identifier for your account/team

### 3. Configure Variables

Update `terraform.tfvars` with your values:

```hcl
render_api_key    = "your-api-key-here"
render_owner_id   = "your-owner-id-here"
service_name      = "my-app"
github_repo       = "https://github.com/username/repo-name"
branch            = "main"
region            = "oregon"  # or "ohio"
plan              = "free"    # free, starter, standard, pro
build_command     = "npm run build"
start_command     = "npm start"
custom_domain     = "myapp.com"  # optional

environment_variables = {
  NODE_ENV = "production"
  API_URL  = "https://api.example.com"
  # Add more environment variables as needed
}
```

### 4. Initialize Terraform

```bash
terraform init
```

### 5. Plan Deployment

```bash
terraform plan
```

### 6. Apply Configuration

```bash
terraform apply
```

## Outputs

After deployment, Terraform will output:

- `service_id` - Your Render service ID
- `service_url` - The public URL of your deployed service
- `deployment_id` - The deployment ID
- `custom_domain` - Your custom domain if configured

## Updating the Service

To update environment variables or rebuild:

```bash
terraform apply
```

## Destroying the Service

To remove the Render service:

```bash
terraform destroy
```

## Common Render Plan Types

- **Free** - Limited resources, suitable for development
- **Starter** - $7/month, 0.5 vCPU, 512MB RAM
- **Standard** - $25/month, 1 vCPU, 2GB RAM
- **Pro** - $50/month, 2 vCPU, 4GB RAM

## Regions

- `oregon` - US West
- `ohio` - US East
- `frankfurt` - Europe
- `singapore` - Asia

## Additional Resources

- [Render Terraform Provider Docs](https://registry.terraform.io/providers/render-oss/render/latest/docs)
- [Render Documentation](https://docs.render.com)
