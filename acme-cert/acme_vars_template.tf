variable "cert_path" {
  default = "/etc/lets_encrypt/..."
}

variable "cn" {
  default = "foo.bar.baz"
}

variable "dns" {
  default = "duckdns"
}

variable "duck_token" {
  default = "abc123"
}

variable "email" {
  default = "foo@bar.baz"
}

variable "san" {
  type = list(string)
  default = [
    "zip.zap.baz"
  ]
}

variable "staging_url" {
  default = "https://acme-staging-v02.api.letsencrypt.org/directory"
}

variable "prod_url" {
  default = "https://acme-v02.api.letsencrypt.org/directory"
}
