resource "proxmox_vm_qemu" "vm" {
	# нода кластера Proxmox, на которой запустится код
  target_node = var.pve_node

  # метаданные
	tags       = "k8s,opentofu"
  vmid       = var.vm_id
  name       = var.vm_name

	# какой темплейт клонируем, qemu-guest-agent и запуск ВМ при старте гипервизора
  clone      = var.template_name
  full_clone = true
  agent      = 1
  onboot     = true

	# ОЗУ, ЦПУ
  memory    = 2048
  cpu {
    cores 		= 1
    sockets   = 1
    type  = "host"
  }

	# загрузка ОС, диски
  boot      = "order=virtio0"
  bios      = "seabios"
  scsihw    = "virtio-scsi-pci"

  # сеть
  ipconfig0  = "ip=${var.vm_ip},gw=${var.pve_subnet_gw}"
  # параметр для удобства вывода
  skip_ipv6  = true

	# DNS
  nameserver   = var.nameserver
  searchdomain = var.searchdomain

	# желаемое состояние
  vm_state         = "running"
  automatic_reboot = true

  # настройки Cloud-Init
  ciuser     = var.os_username
  cipassword = var.os_password
  sshkeys    = var.ssh_keys
  # автообновления cloudinit мешают установке пакетов
  ciupgrade = false

  serial {
    id = 0
  }

  vga {
    type   = "std"
    memory = "16"
  }

  disks {
    ide {
      ide3 {
        cloudinit {
          storage = var.storage_name
        }
      }
    }
    virtio {
      virtio0 {
        disk {
          storage = var.storage_name
          # override disk size
          size      = "10G"
          replicate = true
        }
      }
    }
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
    tag    = 0
  }
}

terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc9"
    }
  }
}