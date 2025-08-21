locals {
  ansible_inventory = templatefile("${path.module}/templates/ansible/inventory/hosts.yml.tpl", {
    masters = [
      for mod in values(module.k8s-masters) : {
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

resource "local_file" "ansible-inventory" {
	depends_on = [module.k8s-masters, module.k8s-workers]

  filename = "${path.module}/ansible/inventory/hosts.yml"
  content  = local.ansible_inventory
}
