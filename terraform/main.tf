# Network
resource "docker_network" "reverse_proxy" {
  name   = "reverse-proxy"
  driver = "bridge"
}

# Volumes
resource "docker_volume" "grafana_data" {
  name = "grafana_data"
}

# Images
resource "docker_image" "reverse_proxy_image" {
  name = "nginx-reverse-proxy"
  build {
    context    = abspath("${path.module}/..")
    dockerfile = abspath("${path.module}/../Dockerfile")
  }
}

resource "docker_image" "nginx_exporter" {
  name = "nginx/nginx-prometheus-exporter:latest"
}

resource "docker_image" "node_exporter" {
  name = "prom/node-exporter:latest"
}

resource "docker_image" "prometheus" {
  name = "prom/prometheus"
}

resource "docker_image" "grafana" {
  name = "grafana/grafana"
}

# Containers
resource "docker_container" "reverse_proxy" {
  name    = "nginx-proxy"
  image   = docker_image.reverse_proxy_image.image_id
  restart = "always"

  networks_advanced {
    name = docker_network.reverse_proxy.name
  }

  ports {
    internal = 80
    external = 80
  }
  ports {
    internal = 443
    external = 443
  }

  volumes {
    host_path      = local.nginx_conf_abs
    container_path = "/etc/nginx/nginx.conf"
  }
  volumes {
    host_path      = local.nginx_conf_d_abs
    container_path = "/etc/nginx/conf.d/"
  }
  volumes {
    host_path      = local.ssl_path_abs
    container_path = "/etc/nginx/ssl"
    read_only      = true
  }
  volumes {
    host_path      = local.htpasswd_abs
    container_path = "/etc/nginx/.htpasswd"
    read_only      = true
  }
}

resource "docker_container" "nginx_exporter" {
  name    = "nginx-exporter"
  image   = docker_image.nginx_exporter.image_id
  restart = "always"
  command = ["--nginx.scrape-uri=http://nginx-proxy:8080/nginx_status"]

  networks_advanced {
    name = docker_network.reverse_proxy.name
  }

  ports {
    internal = 9113
    external = 9113
  }

  depends_on = [docker_container.reverse_proxy]
}

resource "docker_container" "node_exporter" {
  name    = "node-exporter"
  image   = docker_image.node_exporter.image_id
  restart = "always"

  networks_advanced {
    name = docker_network.reverse_proxy.name
  }

  volumes {
    host_path      = "/proc"
    container_path = "/host/proc"
    read_only      = true
  }
  volumes {
    host_path      = "/sys"
    container_path = "/host/sys"
    read_only      = true
  }
  volumes {
    host_path      = "/"
    container_path = "/rootfs"
    read_only      = true
  }

  command = [
    "--path.procfs=/host/proc",
    "--path.sysfs=/host/sys",
    "--path.rootfs=/rootfs"
  ]
}

resource "docker_container" "prometheus" {
  name    = "prometheus"
  image   = docker_image.prometheus.image_id
  restart = "always"

  networks_advanced {
    name = docker_network.reverse_proxy.name
  }

  volumes {
    host_path      = local.prometheus_path_abs
    container_path = "/etc/prometheus/prometheus.yml"
  }

  command = ["--config.file=/etc/prometheus/prometheus.yml"]
}

resource "docker_container" "grafana" {
  name    = "grafana"
  image   = docker_image.grafana.image_id
  restart = "always"

  networks_advanced {
    name = docker_network.reverse_proxy.name
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
