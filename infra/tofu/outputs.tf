output "vms" {
  description = "Nom et VMID assigné par Proxmox"
  value = {
    for u, r in proxmox_virtual_environment_vm.debian_user :
    u => {
      name = r.name
      vmid = r.vm_id
      node = r.node_name
      ip   = try(r.ipv4_addresses[0], "N/A")
    }
  }
}
