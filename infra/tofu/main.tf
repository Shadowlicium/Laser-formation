terraform {
  required_version = ">= 1.6.0"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.80.0"
    }
  }
}

provider "proxmox" {
  endpoint  = var.pve_api_url
  api_token = var.pve_token_id
  insecure  = var.pve_tls_insecure
}

resource "proxmox_virtual_environment_vm" "debian_user" {
  for_each  = toset(var.users)

  node_name = var.pve_node_name
  name      = "${var.vm_prefix}-${each.value}"

  operating_system {
    type = "l26"
  }

  cpu {
    sockets = 1
    cores   = var.cores
    type    = "x86-64-v2-AES"
  }

  memory {
    dedicated = var.memory
  }

  disk {
    datastore_id = var.datastore_id
    interface    = "scsi0"
    size         = var.disk_size_gb
    iothread     = true
  }

  network_device {
    bridge = var.net_bridge
    model  = "virtio"
  }

  clone {
    vm_id = 9000
    full  = true
  }

  initialization {
    datastore_id = var.datastore_id

    user_account {
      username = "nono"
      password = var.user_password
      keys     = [ file(var.ssh_pub_key) ]
    }

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    # ✅ On fait référence directement au fichier déjà présent sur le Proxmox
    user_data_file_id = "local:snippets/cloudinit-nono.yml"
  }

  tags = ["generated", "debian", "users"]
}
