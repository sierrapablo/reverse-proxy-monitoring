variable "ssl_path" {
  description = "Local path to SSL certificates"
  type        = string
  default     = "../ssl"
}

locals {
  ssl_path_abs = abspath("${path.module}/${var.ssl_path}")
}