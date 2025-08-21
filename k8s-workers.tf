variable "k8s-workers-count" {
	default     = 2
	description = "Количество воркер нод для кластера."
}

module k8s-workers {
	depends_on = [module.k8s-masters]
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
