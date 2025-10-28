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
  api_token = "${var.pve_token_id}=${var.pve_token_secret}"
  insecure  = var.pve_tls_insecure                 # false si cert public; true si cert interne
}

# Une VM Debian par utilisateur (nom = "<prefix>-<user>"), VMID auto (on omet vm_id)
resource "proxmox_virtual_environment_vm" "debian_user" {
  for_each  = toset(var.users)

  node_name = var.pve_node_name
  name      = "${var.vm_prefix}-${each.value}"

  # Ajuste si besoin
  cores  = var.cores
  memory = var.memory

  # Disque principal (datastore sur NAS ou local-lvm)
  disk {
    datastore_id = var.datastore_id
    size         = var.disk_size_gb               # en Go
    interface    = "virtio0"
    iothread     = true
  }

  # Réseau (si nécessaire selon ta config Proxmox)
  # network_device {
  #   bridge = var.net_bridge
  #   model  = "virtio"
  # }

  # Cloud-init : injecte la clé publique générée par le workflow
  initialization {
    hostname = "${var.vm_prefix}-${each.value}"
    user_account {
      username             = "debian"
      ssh_authorized_keys  = [ file(var.ssh_pub_key) ]  # <-- le workflow passe un CHEMIN vers la clé publique
    }
    datasource = "NoCloud"
  }

  tags = ["generated","debian","users"]
}
