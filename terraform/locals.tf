locals {
  nginx_conf_abs      = abspath("${path.module}/${var.nginx_conf_path}")
  nginx_conf_d_abs    = abspath("${path.module}/${var.nginx_conf_d_path}")
  ssl_path_abs        = abspath("${path.module}/${var.ssl_path}")
  htpasswd_abs        = abspath("${path.module}/${var.htpasswd_path}")
  grafana_path_abs    = abspath("${path.module}/${var.grafana_provisioning_path}")
  prometheus_path_abs = abspath("${path.module}/${var.prometheus_config_path}")
}
