variable "ssl_path" {
  description = "Local path to SSL certificates"
  type        = string
  default     = "../ssl"
}

variable "htpasswd_path" {
  description = "Local path to .htpasswd"
  type        = string
  default     = "../.htpasswd"
}