variable "k8s-controllers" {
	type        = map(any)
	default     = {
		controller = {
			vm_ip		= "192.168.122.111/24"
			vm_id 	= "111"
			vm_name = "k8s-controller"
		}
	}
	description = "description"
}

variable "k8s-workers-count" {
	default     = 2
	description = "description"
}

module k8s-controller-vm {
	source = "./modules/proxmox-vm"
	
	# тут хотим плодить контроллеры через for_each
	for_each = var.k8s-controllers

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

module k8s-workers-vm {
	source  = "./modules/proxmox-vm"

	count   = var.k8s-workers-count

	vm_id   = 121 + count.index
	vm_ip   = format("%s.%s/24", var.pve_subnet, (121 + count.index))
	vm_name = format("k8s-worker-%02d", (count.index + 1))

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
