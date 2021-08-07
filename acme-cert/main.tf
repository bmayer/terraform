terraform {
  required_providers {
    acme = {
      source  = "vancluever/acme"
      version = "~> 2.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }
  }
}

provider "acme" {
  server_url = var.staging_url
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = "${tls_private_key.private_key.private_key_pem}"
  email_address   = var.email
}

resource "acme_certificate" "certificate" {
  account_key_pem           = "${acme_registration.reg.account_key_pem}"
  common_name               = var.cn
  subject_alternative_names = var.san

  dns_challenge {
    provider = var.dns
    config   = {
      DUCKDNS_TOKEN = var.duck_token
    }
    
  }
}

provider "local" {
  # Configuration options
}

resource "local_file" "certificate" {
    content              = acme_certificate.certificate.certificate_pem
    directory_permission = 755
    file_permission      = 440
    filename             = var.acme_cert_path
}

resource "local_file" "chain" {
    content              = "${acme_certificate.certificate.certificate_pem}${acme_certificate.certificate.issuer_pem}"
    directory_permission = 755
    file_permission      = 440
    filename             = var.acme_chain_path
}

resource "local_file" "issuer" {
    content              = acme_certificate.certificate.issuer_pem
    directory_permission = 755
    file_permission      = 440
    filename             = var.acme_issuer_path
}

resource "local_file" "key" {
    content              = acme_certificate.certificate.private_key_pem
    directory_permission = 755
    file_permission      = 440
    filename             = var.acme_key_path
}
