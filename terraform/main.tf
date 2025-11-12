terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# --- Network ---
resource "docker_network" "reverse_proxy" {
  name   = "reverse-proxy"
  driver = "bridge"
}

# --- Volume for Grafana data ---
resource "docker_volume" "grafana_data" {
  name = "grafana_data"
}

# --- Reverse Proxy (NGINX) ---
resource "docker_image" "reverse_proxy" {
  name = "nginx-proxy:latest"
  build {
    context = "${path.root}/docker/reverse-proxy-monitoring"
  }
}

resource "docker_container" "reverse_proxy" {
  name    = "nginx-proxy"
  image   = docker_image.reverse_proxy.latest
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
    host_path      = "${path.root}/docker/reverse-proxy-monitoring/nginx/nginx.conf"
    container_path = "/etc/nginx/nginx.conf"
  }

  volumes {
    host_path      = "${path.root}/docker/reverse-proxy-monitoring/nginx/conf.d/"
    container_path = "/etc/nginx/conf.d/"
  }

  volumes {
    host_path      = var.ssl_certificate
    container_path = "/etc/nginx/ssl/certificate.pem"
    read_only      = true
  }

  volumes {
    host_path      = var.ssl_certificate_key
    container_path = "/etc/nginx/ssl/certificate.key"
    read_only      = true
  }

  volumes {
    host_path      = "${path.root}/docker/reverse-proxy-monitoring/.htpasswd"
    container_path = "/etc/nginx/.htpasswd"
    read_only      = true
  }

  env = {
    PROMETHEUS_HOST = var.prometheus_host
    GRAFANA_HOST    = var.grafana_host
  }

  depends_on = [
    docker_container.prometheus,
    docker_container.grafana
  ]
}

# --- NGINX Exporter ---
resource "docker_image" "nginx_exporter" {
  name = "nginx/nginx-prometheus-exporter:latest"
}

resource "docker_container" "nginx_exporter" {
  name    = "nginx-exporter"
  image   = docker_image.nginx_exporter.latest
  restart = "always"

  networks_advanced {
    name = docker_network.reverse_proxy.name
  }

  depends_on = [docker_container.reverse_proxy]

  command = ["--nginx.scrape-uri=http://reverse-proxy:8080/nginx_status"]

  ports {
    internal = 9113
    external = 9113
  }
}

# --- Node Exporter ---
resource "docker_image" "node_exporter" {
  name = "prom/node-exporter:latest"
}

resource "docker_container" "node_exporter" {
  name    = "node-exporter"
  image   = docker_image.node_exporter.latest
  restart = "always"

  networks_advanced {
    name = docker_network.reverse_proxy.name
  }

  pid = "host"

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

# --- Prometheus ---
resource "docker_image" "prometheus" {
  name = "prom/prometheus:latest"
}

resource "docker_container" "prometheus" {
  name    = "prometheus"
  image   = docker_image.prometheus.latest
  restart = "always"

  networks_advanced {
    name = docker_network.reverse_proxy.name
  }

  volumes {
    host_path      = "${path.root}/docker/reverse-proxy-monitoring/prometheus/prometheus.yml"
    container_path = "/etc/prometheus/prometheus.yml"
  }

  command = ["--config.file=/etc/prometheus/prometheus.yml"]
}

# --- Grafana ---
resource "docker_image" "grafana" {
  name = "grafana/grafana:latest"
}

resource "docker_container" "grafana" {
  name    = "grafana"
  image   = docker_image.grafana.latest
  restart = "always"

  networks_advanced {
    name = docker_network.reverse_proxy.name
  }

  volumes {
    container_path = "/var/lib/grafana"
    volume_name    = docker_volume.grafana_data.name
  }

  volumes {
    host_path      = "${path.root}/docker/reverse-proxy-monitoring/grafana/provisioning/"
    container_path = "/etc/grafana/provisioning/"
  }

  env = {
    GF_SECURITY_ADMIN_USER     = var.grafana_user
    GF_SECURITY_ADMIN_PASSWORD = var.grafana_password
  }
}
