terraform {
  required_providers {
    render = {
      source = "render-oss/render"
      version = "~> 1.0"
    }
  }
}

provider "render" {
  api_key = var.render_api_key
}

# Create a Render service (Web Service)
resource "render_service" "main" {
  type           = "web_service"
  name           = var.service_name
  owner_id       = var.render_owner_id
  repo           = var.github_repo
  branch         = var.branch
  region         = var.region
  plan           = var.plan
  
  # Docker configuration
  runtime              = var.runtime
  dockerfile_path      = var.dockerfile_path
  
  # Environment variables
  environment_variables = var.environment_variables
  
  depends_on = []
}

# Set custom domain if provided
resource "render_custom_domain" "main" {
  count       = var.custom_domain != "" ? 1 : 0
  service_id  = render_service.main.id
  domain_name = var.custom_domain
  
  depends_on = [render_service.main]
}

# Trigger initial deployment
resource "render_deployment" "main" {
  service_id = render_service.main.id
  clear_cache = true
  
  depends_on = [
    render_service.main
  ]
}
