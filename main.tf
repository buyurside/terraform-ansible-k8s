module k8s-controllers {
	source = "./modules/proxmox-vm"
	
	# тут хотим через for_each плодить контроллеры со сложной кастомизацией
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

data "template_file" "ansible_inventory_k8s" {
  template = file("${path.module}/templates/ansible/inventory/k8s/hosts.tpl")

  vars = {
    controller_ips = join("\n", [
      for name, mod in module.k8s-controllers :
        regex("\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}", mod.ipconfig0)
    ])
    worker_ips     = join("\n", [
      for name, mod in module.k8s-workers :
        regex("\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}", mod.ipconfig0)
    ])
  }
}

resource "local_file" "ansible_inventory_k8s" {
  content  = data.template_file.ansible_inventory_k8s.rendered
  filename = "${path.module}/ansible/inventory/k8s/hosts"
}
