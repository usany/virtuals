variable "vercel_api_token" {
  type        = string
  description = "Vercel API token for authentication"
  sensitive   = true
}

variable "github_token" {
  type        = string
  description = "GitHub personal access token for repository access"
  sensitive   = true
}

variable "github_repo" {
  type        = string
  description = "GitHub repository in format: username/repo-name"
}

variable "project_name" {
  type        = string
  description = "Name of the Vercel project"
}

variable "framework" {
  type        = string
  description = "Framework type (nextjs, react, vue, svelte, static, etc.)"
  default     = "nextjs"
}

variable "build_command" {
  type        = string
  description = "Build command for the project"
  default     = "npm run build"
}

variable "output_directory" {
  type        = string
  description = "Output directory of the build"
  default     = ".next"
}

variable "install_command" {
  type        = string
  description = "Install command for dependencies"
  default     = "npm install"
}

variable "environment_variables" {
  type        = map(string)
  description = "Environment variables for the project"
  default = {
    NODE_ENV = "production"
  }
}

variable "custom_domain" {
  type        = string
  description = "Custom domain for the project (optional)"
  default     = ""
}
