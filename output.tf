output "k8s-controllers-info" {
  value = join("\n\n", [
    for name, mod in module.k8s-controllers :
    format(
      "VM: %s\nID: %s\nipconfig: %s",
      mod.name,
      mod.vmid,
      mod.ipconfig0
    )
  ])
}

output "k8s-workers-info" {
  value = join("\n\n", [
    for name, mod in module.k8s-workers :
    format(
      "VM: %s\nID: %s\nipconfig: %s",
      mod.name,
      mod.vmid,
      mod.ipconfig0
    )
  ])
}
