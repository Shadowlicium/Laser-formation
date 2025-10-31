output "vms" {
  description = "Nom, node et VMID assigné par Proxmox"
  value = {
    for u, r in proxmox_virtual_environment_vm.debian_user :
    u => {
      name = r.name
      node = r.node_name
      vmid = r.vm_id
    }
  }
}
