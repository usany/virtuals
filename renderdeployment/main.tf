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
  
  build_command = var.build_command
  start_command = var.start_command
  
  # Environment variables
  environment_slug = "docker"
  
  depends_on = []
}

# Set environment variables for the service
resource "render_env_group" "main" {
  name       = "${var.service_name}-env"
  service_id = render_service.main.id
  
  env_vars = var.environment_variables
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
    render_service.main,
    render_env_group.main
  ]
}
