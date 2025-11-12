variable "ssl_certificate" {
  description = "Path to the SSL certificate"
  type        = string
}

variable "ssl_certificate_key" {
  description = "Path to the SSL private key"
  type        = string
}

variable "prometheus_host" {
  description = "Hostname for Prometheus"
  type        = string
}

variable "grafana_host" {
  description = "Hostname for Grafana"
  type        = string
}

variable "grafana_user" {
  description = "Grafana admin username"
  type        = string
}

variable "grafana_password" {
  description = "Grafana admin password, needs to be changed on first logging in"
  type        = string
}
