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

chpasswd:
  list: |
    nono:changeme
  expire: false

package_update: true
package_upgrade: true
packages:
  - qemu-guest-agent
  - fail2ban
  - vim
  - curl
  - git
  - htop
  - avahi-daemon

mounts:
  - [ "${NFS_SERVER}:/srv/nfs/users/${USERNAME}", "/mnt/data/${USERNAME}", "nfs", "defaults,_netdev", "0", "0" ]

runcmd:
  - systemctl reboot
