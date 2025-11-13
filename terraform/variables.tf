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

variable "nginx_conf_path" {
  description = "Local path to nginx.conf"
  type        = string
  default     = "${path.module}/nginx/nginx.conf"
}

variable "nginx_conf_d_path" {
  description = "Local path to nginx conf.d directory"
  type        = string
  default     = "${path.module}/nginx/conf.d/"
}

variable "ssl_path" {
  description = "Local path to SSL certificates"
  type        = string
  default     = "${path.module}/ssl"
}

variable "htpasswd_path" {
  description = "Local path to .htpasswd"
  type        = string
  default     = "${path.module}/.htpasswd"
}

variable "grafana_provisioning_path" {
  description = "Local path to Grafana provisioning directory"
  type        = string
  default     = "${path.module}/grafana/provisioning/"
}

variable "prometheus_config_path" {
  description = "Local path to Prometheus config file"
  type        = string
  default     = "${path.module}/prometheus/prometheus.yml"
}
