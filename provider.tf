terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc9"
    }
    local = {
      source = "hashicorp/local"
      version = "2.5.3"
    }
    null = {
      source = "hashicorp/null"
      version = "3.2.4"
    }
  }
}

provider "proxmox" {
  pm_api_url      = var.ve_endpoint
  pm_tls_insecure = true
  pm_debug        = true
}
