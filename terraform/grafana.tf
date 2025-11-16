resource "docker_volume" "grafana_data" {
  name = "grafana_data"
}

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
    volume_name    = docker_volume.grafana_data.name
    container_path = "/var/lib/grafana"
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