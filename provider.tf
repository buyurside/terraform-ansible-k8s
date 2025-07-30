terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc9"
    }
  }
}

provider "proxmox" {
  pm_api_url      = var.ve_endpoint
  pm_tls_insecure = true
  pm_debug        = true
}
