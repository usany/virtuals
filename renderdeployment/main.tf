terraform {
  required_providers {
    render = {
      source = "render-oss/render"
      version = "~> 1.0"
    }
  }
}

provider "render" {
  api_key  = var.render_api_key
  owner_id = var.render_owner_id
}

# Create a Render Web Service
resource "render_web_service" "main" {
  name   = var.service_name
  plan   = var.plan
  region = var.region
  
  runtime_source = {
    docker = {
      auto_deploy    = true
      branch         = var.branch
      repo_url       = var.github_repo
      dockerfile_path = var.dockerfile_path
    }
  }
}
