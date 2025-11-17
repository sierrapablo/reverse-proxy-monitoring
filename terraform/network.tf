# Network
resource "docker_network" "reverse_proxy" {
  name   = "reverse-proxy"
  driver = "bridge"
}

output "reverse_proxy_network_id" {
  description = "Docker network ID for the reverse-proxy network"
  value       = docker_network.reverse_proxy.id
}