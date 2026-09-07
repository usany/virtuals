terraform {
  required_providers {
    vercel = {
      source = "vercel/vercel"
      version = "~> 0.3"
    }
  }
}

provider "vercel" {
  api_token = var.vercel_api_token
}

resource "vercel_project" "main" {
  name      = var.project_name
  framework = var.framework
  
  git_repository = {
    type = "github"
    repo = var.github_repo
  }
  
  build_command    = var.build_command
  output_directory = var.output_directory
  install_command  = var.install_command
}

resource "vercel_project_domain" "main" {
  count      = var.custom_domain != "" ? 1 : 0
  project_id = vercel_project.main.id
  domain     = var.custom_domain
}

