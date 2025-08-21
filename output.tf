output "k8s-masters-info" {
  value = join("\n\n", [
    for name, mod in module.k8s-masters :
    format(
      "VM: %s\nID: %s\nipv4: %s",
      mod.name,
      mod.vmid,
      regex("\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}", mod.ipconfig0)
    )
  ])
}

output "k8s-workers-info" {
  value = join("\n\n", [
    for name, mod in module.k8s-workers :
    format(
      "VM: %s\nID: %s\nipv4: %s",
      mod.name,
      mod.vmid,
      regex("\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}", mod.ipconfig0)
    )
  ])
}
