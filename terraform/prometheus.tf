resource "docker_image" "prometheus" {
  name = "prom/prometheus"
}

resource "docker_container" "prometheus" {
  name    = "prometheus"
  image   = docker_image.prometheus.image_id
  restart = "always"

  networks_advanced {
    name = docker_network.reverse_proxy.name
  }

  ports {
    internal = 4000
    external = 4000
  }

  volumes {
    host_path      = local.prometheus_path_abs
    container_path = "/etc/prometheus/prometheus.yml"
  }

  command = ["--config.file=/etc/prometheus/prometheus.yml"]
}