output "grafana_url" {
  description = "Public URL to access Grafana"
  value       = "https://${var.grafana_host}"
}

output "prometheus_url" {
  description = "Public URL to access Prometheus"
  value       = "https://${var.prometheus_host}"
}

output "grafana_credentials" {
  description = "Grafana admin user (password is stored securely in state)"
  value = {
    username = var.grafana_user
  }
  sensitive = true
}

output "reverse_proxy_status" {
  description = "Reverse proxy container details"
  value = {
    name   = docker_container.reverse_proxy.name
    image  = docker_image.reverse_proxy.name
    status = docker_container.reverse_proxy.status
  }
}

output "network_name" {
  description = "Docker network created for reverse proxy and monitoring stack"
  value       = docker_network.reverse_proxy.name
}

output "grafana_volume" {
  description = "Grafana persistent volume name"
  value       = docker_volume.grafana_data.name
}
