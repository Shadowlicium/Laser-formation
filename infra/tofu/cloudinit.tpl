#cloud-config
hostname: debian-${USERNAME}
users:
  - name: ${USERNAME}
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh_authorized_keys:
      - ${PUBKEY}
  - name: nono
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: sudo
    shell: /bin/bash
    lock_passwd: false
    passwd: changeme
package_update: true
package_upgrade: true
packages:
  - nginx
  - fail2ban
  - vim
  - curl
  - git
  - htop
  - avahi-daemon
runcmd:
  - systemctl enable nginx
  - systemctl start nginx
  - echo "<html><body><h1>VM ${USERNAME}</h1><p>Déployée automatiquement avec OpenTofu + Cloud-Init.</p></body></html>" > /var/www/html/index.html
