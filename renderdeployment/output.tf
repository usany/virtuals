output "service_id" {
  description = "Render service ID"
  value       = render_service.main.id
}

output "service_url" {
  description = "Render service URL"
  value       = render_service.main.service_url
}

output "deployment_id" {
  description = "Initial deployment ID"
  value       = render_deployment.main.id
}

output "custom_domain" {
  description = "Custom domain for the service"
  value       = var.custom_domain != "" ? render_custom_domain.main[0].domain_name : "Not configured"
}
