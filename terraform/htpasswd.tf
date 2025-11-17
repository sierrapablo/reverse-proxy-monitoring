variable "htpasswd_path" {
  description = "Local path to .htpasswd"
  type        = string
  default     = "../.htpasswd"
}

locals {
  htpasswd_abs = abspath("${path.module}/${var.htpasswd_path}")
}