#cloud-config
hostname: ${name}
manage_etc_hosts: true
preserve_hostname: false

users:
  - name: ubuntu
    groups: [adm, cdrom, dip, plugdev, lxd, sudo]
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh_authorized_keys:
      - ${ssh_public_key}

package_update: true
package_upgrade: true

packages:
  - qemu-guest-agent
  - haproxy

write_files:
  - path: /etc/haproxy/haproxy.cfg
    content: |
      global
          log /dev/log    local0
          log /dev/log    local1 notice
          chroot /var/lib/haproxy
          stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
          stats timeout 30s
          user haproxy
          group haproxy
          daemon

      defaults
          log     global
          mode    tcp
          option  tcplog
          option  dontlognull
          timeout connect 5000
          timeout client  50000
          timeout server  50000

      frontend kubernetes-frontend
          bind *:6443
          mode tcp
          default_backend kubernetes-backend

      backend kubernetes-backend
          mode tcp
          balance roundrobin
          option tcp-check
          server cp1 192.168.0.80:6443 check fall 3 rise 2
          server cp2 192.168.0.81:6443 check fall 3 rise 2
          server cp3 192.168.0.82:6443 check fall 3 rise 2

runcmd:
  - systemctl enable qemu-guest-agent
  - systemctl start qemu-guest-agent
  - systemctl enable haproxy
  - systemctl restart haproxy

power_state:
  mode: reboot
  timeout: 300
  condition: true