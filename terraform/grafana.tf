resource "docker_image" "grafana" {
  name = "grafana/grafana"
}

resource "docker_container" "grafana" {
  name    = "grafana"
  image   = docker_image.grafana.image_id
  restart = "always"

  networks_advanced {
    name = docker_network.reverse_proxy.name
  }

  ports {
    internal = 3000
    external = 3000
  }

  volumes {
    host_path      = local.grafana_path_abs
    container_path = "/etc/grafana/provisioning/"
  }

  env = [
    "GF_SECURITY_ADMIN_USER=${var.grafana_admin_user}",
    "GF_SECURITY_ADMIN_PASSWORD=${var.grafana_admin_password}"
  ]
}

variable "grafana_admin_user" {
  description = "Admin username for Grafana"
  type        = string
  default     = "admin"
}

variable "grafana_admin_password" {
  description = "Admin password for Grafana"
  type        = string
  sensitive   = true
  default     = "changeme" # needs to be changed on first logging in
}

variable "grafana_provisioning_path" {
  description = "Local path to Grafana provisioning directory"
  type        = string
  default     = "../grafana/provisioning/"
}

locals {
  grafana_path_abs = abspath("${path.module}/${var.grafana_provisioning_path}")
}