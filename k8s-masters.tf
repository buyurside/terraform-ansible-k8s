variable "k8s-masters-params" {
	type        = map(any)
	default     = {
		master = {
			vm_ip		= "192.168.122.111/24"
			vm_id 	= "111"
			vm_name = "k8s-master-01"
		}
	}
	description = "Мапа с ipv4, id и названием виртуальных машин."
}

module k8s-masters {
	source = "./modules/proxmox-vm"
	
	# тут хотим через for_each плодить контроллеры с кастомизацией каждого
	for_each = var.k8s-masters-params

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
