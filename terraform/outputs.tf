# Docker network ID for the reverse proxy
output "reverse_proxy_network_id" {
  description = "Docker network ID for the reverse-proxy network"
  value       = docker_network.reverse_proxy.id
}

# Internal IP of the nginx-proxy container
output "reverse_proxy_ip" {
  description = "Internal IP address of the nginx-proxy container in the reverse-proxy network"
  value       = docker_container.reverse_proxy.network_data[0].ip_address
}

# Exposed ports of the nginx-proxy container
output "reverse_proxy_ports" {
  description = "Ports exposed by the nginx-proxy container"
  value = {
    http  = docker_container.reverse_proxy.ports[0].external
    https = docker_container.reverse_proxy.ports[1].external
  }
}

# Exposed ports of the nginx-exporter container
output "nginx_exporter_ports" {
  description = "Ports exposed by the nginx-exporter container"
  value = {
    metrics = docker_container.nginx_exporter.ports[0].external
  }
}

output "nginx_exporter_url" {
  description = "URL to access Nginx Exporter metrics"
  value       = "http://localhost:${docker_container.nginx_exporter.ports[0].external}/metrics"
}

# Node Exporter container info
output "node_exporter_info" {
  description = "Information about the Node Exporter container"
  value = {
    name  = docker_container.node_exporter.name
    ports = docker_container.node_exporter.ports
  }
}
