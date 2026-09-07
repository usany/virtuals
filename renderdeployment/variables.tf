variable "render_api_key" {
  type        = string
  description = "Render API key for authentication"
  sensitive   = true
}

variable "github_token" {
  type        = string
  description = "GitHub personal access token for repository access"
  sensitive   = true
}

variable "github_repo" {
  type        = string
  description = "GitHub repository URL (e.g., https://github.com/username/repo-name)"
}

variable "render_owner_id" {
  type        = string
  description = "Render account/team owner ID"
}

variable "service_name" {
  type        = string
  description = "Name of the Render service"
}

variable "branch" {
  type        = string
  description = "Git branch to deploy from"
  default     = "main"
}

variable "region" {
  type        = string
  description = "Render region for deployment (e.g., oregon, ohio)"
  default     = "oregon"
}

variable "plan" {
  type        = string
  description = "Render plan type (free, starter, standard, pro)"
  default     = "free"
}

variable "build_command" {
  type        = string
  description = "Build command for the project"
  default     = "npm run build"
}

variable "start_command" {
  type        = string
  description = "Start command to run the application"
  default     = "npm start"
}

variable "environment_variables" {
  type        = map(string)
  description = "Environment variables for the service"
  default = {
    NODE_ENV = "production"
  }
}

variable "custom_domain" {
  type        = string
  description = "Custom domain for the service (optional)"
  default     = ""
}
