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