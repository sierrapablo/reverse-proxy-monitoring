resource "docker_image" "node_exporter" {
  name = "prom/node-exporter:latest"
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