terraform {
  required_version = ">= 1.6.0"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.80.0"
    }
  }
}

# Provider Proxmox
provider "proxmox" {
  endpoint  = var.pve_api_url
  api_token = var.pve_token_id
  insecure  = var.pve_tls_insecure
}

# Création d'une VM Debian par utilisateur
resource "proxmox_virtual_environment_vm" "debian_user" {
  for_each  = toset(var.users)

  node_name = var.pve_node_name
  name      = "${var.vm_prefix}-${each.value}"

  # Type d’OS invité
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

  # Disque principal
  disk {
    datastore_id = var.datastore_id
    interface    = "scsi0"
    size         = var.disk_size_gb
    iothread     = true
  }

  # Réseau
  network_device {
    bridge = var.net_bridge
    model  = "virtio"
  }

  # Clone du template cloud-init (ID = 9000)
  clone {
    vm_id = 9000
    full  = true
  }

  # Initialisation (cloud-init)
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

    # 💡 Script cloud-init exécuté automatiquement au premier boot
    user_data = <<-EOF
      #cloud-config
      package_update: true
      package_upgrade: true
      packages:
        - nginx
        - fail2ban
        - vim
        - curl
        - git
        - htop
      runcmd:
        - systemctl enable nginx
        - systemctl start nginx
        - echo "<html><body><h1>VM ${each.value}</h1><p>Déployée automatiquement avec Opentofu + Cloud-Init.</p></body></html>" > /var/www/html/index.html
    EOF
  }

  tags = ["generated", "debian", "users"]
}
