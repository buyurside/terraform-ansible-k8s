module k8s-controllers {
	source = "./modules/proxmox-vm"
	
	# тут хотим через for_each плодить контроллеры с кастомизацией каждого
	for_each = var.k8s-controllers-params

	vm_id   = each.value.vm_id
	vm_ip   = each.value.vm_ip
	vm_name = each.value.vm_name

  ve_endpoint   = var.ve_endpoint 
  pve_node      = var.pve_node 
  storage_name  = var.storage_name 
  ssh_keys      = var.ssh_keys 
  
  template_name = var.template_name 
  
  searchdomain  = var.searchdomain 
  nameserver    = var.nameserver 
  pve_subnet_gw = var.pve_subnet_gw 
  
  os_username   = var.os_username 
}

module k8s-workers {
	source  = "./modules/proxmox-vm"
  
  # а здесь - типовые воркеры, через count
	count   = var.k8s-workers-count
  
	vm_id   = 121 + count.index
	vm_ip   = format("%s.%s/24", var.pve_subnet, (121 + count.index))
	vm_name = format("k8s-worker-%02d", (1 + count.index))

  ve_endpoint   = var.ve_endpoint 
  pve_node      = var.pve_node 
  storage_name  = var.storage_name 
  ssh_keys      = var.ssh_keys 
  
  template_name = var.template_name 
  
  searchdomain  = var.searchdomain 
  nameserver    = var.nameserver 
  pve_subnet_gw = var.pve_subnet_gw 
  
  os_username   = var.os_username 
}

locals {
  ansible_inventory = templatefile("${path.module}/templates/ansible/inventory/hosts.yml.tpl", {
    controllers = [
      for mod in values(module.k8s-controllers) : {
        name = mod.name
        ip   = regex("\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}", mod.ipconfig0)
      }
    ]
    workers = [
      for mod in module.k8s-workers : {
        name = mod.name
        ip   = regex("\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}", mod.ipconfig0)
      }
    ]
  })
}

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/ansible/inventory/hosts.yml"
  content  = local.ansible_inventory
}

resource "null_resource" "always_run" {
  provisioner "local-exec" {
    command = "cd ./ansible/; ./install-k8s.sh"
  }

  triggers = {
    always_run = timestamp()
  }
}
