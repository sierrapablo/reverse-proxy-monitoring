resource "docker_image" "nginx_exporter" {
  name = "nginx/nginx-prometheus-exporter:latest"
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