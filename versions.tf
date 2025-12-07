terraform {
  required_version = "~> 1.10.6"
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.88.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">=4.1.0"
    }
  }
}
