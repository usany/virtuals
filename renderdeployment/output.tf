output "service_id" {
  description = "Render service ID"
  value       = render_web_service.main.id
}

output "service_name" {
  description = "Render service name"
  value       = render_web_service.main.name
}
