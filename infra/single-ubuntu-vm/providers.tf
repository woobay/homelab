terraform {
  required_version = ">= 1.7.0"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.51.1"
    }
  }
}

provider "proxmox" {
  endpoint = "https://192.168.0.200:8006/"
  username = var.proxmox_username
  password = var.proxmox_password
  insecure = true
}
