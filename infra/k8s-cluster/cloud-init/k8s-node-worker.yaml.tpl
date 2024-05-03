#cloud-config
preserve_hostname: true
hostname: ${name}
users:
  - default
  - name: ubuntu
    groups:
      - sudo
    shell: /bin/bash
    ssh_authorized_keys:
      - ${ssh_public_key}
    sudo: ALL=(ALL) NOPASSWD:ALL
package_update: true
package_upgrade: true
packages:
- qemu-guest-agent
- net-tools
runcmd:
    - timedatectl set-timezone America/Toronto
    - systemctl enable qemu-guest-agent
    - systemctl start qemu-guest-agent
    - for i in $(seq 0 ${count-cp - 1}); do sudo bash -c "echo '192.168.0.10$i k8s-cp-$i' >> /etc/hosts"; done
    - for i in $(seq 0 ${count-worker - 1}); do sudo bash -c "echo '192.168.0.11$i k8s-worker-$i' >> /etc/hosts"; done
    - echo "done" > /tmp/cloud-config.done

