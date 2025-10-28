# Liste des utilisateurs (le workflow passera ["alice"] ou similaire)
variable "users" {
  type        = set(string)
  description = "Liste des identifiants utilisateurs"
}

# Clé publique SSH (CHEMIN de fichier, le workflow fournit /tmp/keys/<nom>.pub)
variable "ssh_pub_key" {
  type        = string
  description = "Chemin vers la clé publique à injecter (sera lue avec file())"
}

# Proxmox
variable "pve_api_url"      { type = string }                         # ex: https://api-proxmox.example.com/api2/json
variable "pve_token_id"     { type = string }
variable "pve_token_secret" { type = string }
variable "pve_tls_insecure" { type = bool   default = true }
variable "pve_node_name"    { type = string default = "pve-node1" }

# Stockage / réseau / sizing
variable "datastore_id"   { type = string default = "local-lvm" }
variable "net_bridge"     { type = string default = "vmbr0" }
variable "cores"          { type = number default = 2 }
variable "memory"         { type = number default = 2048 }            # MiB
variable "disk_size_gb"   { type = number default = 20 }              # Go
variable "vm_prefix"      { type = string default = "debian" }        # préfixe des noms de VM
