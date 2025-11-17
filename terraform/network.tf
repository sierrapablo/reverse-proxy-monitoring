# Network
resource "docker_network" "reverse_proxy" {
  name   = "reverse-proxy"
  driver = "bridge"
}