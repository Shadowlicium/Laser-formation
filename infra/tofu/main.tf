terraform {
  required_version = ">= 1.6.0"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.80.0"
    }
  }
}

# Provider Proxmox (API via reverse proxy ou direct)
provider "proxmox" {
  endpoint  = var.pve_api_url                      # ex: https://api-proxmox.example.com/api2/json
  api_token = "${var.pve_token_id}"
  insecure  = var.pve_tls_insecure                 # false si cert public; true si cert interne
}

# Une VM Debian par utilisateur (nom = "<prefix>-<user>"), VMID auto (on n'indique pas vm_id)
resource "proxmox_virtual_environment_vm" "debian_user" {
  for_each  = toset(var.users)

  node_name = var.pve_node_name
  name      = "${var.vm_prefix}-${each.value}"

  # Type d'OS invité
  operating_system {
    type = "l26"   # Linux 2.6+ (générique)
  }

  cpu {
    sockets = 1
    cores   = var.cores
    type    = "x86-64-v2-AES"  # optionnel
  }

  memory {
    dedicated = var.memory      # MiB
  }

  # Disque principal (datastore NFS/iSCSI)
  disk {
    datastore_id = var.datastore_id
    interface    = "scsi0"      # "virtio0" possible aussi
    size         = var.disk_size_gb
    iothread     = true
  }

  # Réseau
  network_device {
    bridge = var.net_bridge
    model  = "virtio"
  }

  clone {
    vm_id = 9000   # <-- VMID du template cloud-init Debian si tu en as un
    full  = true
  }

  # Initialisation (cloud-init)
  initialization {
    datastore_id = var.datastore_id
    user_account {
      username = "debian"
      # IMPORTANT: dans le provider BPG, c'est "keys" (liste de clés publiques)
      keys     = [ file(var.ssh_pub_key) ]   # le workflow passe un CHEMIN vers la clé .pub
    }
    ip_config {
      ipv4 {
        address = "dhcp"
    }
  }
}
  tags = ["generated","debian","users"]
}
