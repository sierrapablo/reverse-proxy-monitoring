resource "docker_image" "reverse_proxy_image" {
  name = "nginx-reverse-proxy"
  build {
    context = abspath("${path.module}/..")
  }
}

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