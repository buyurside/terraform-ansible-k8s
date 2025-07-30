module k8s-controllers {
	source = "./modules/proxmox-vm"
	
	# тут хотим плодить контроллеры через for_each
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
