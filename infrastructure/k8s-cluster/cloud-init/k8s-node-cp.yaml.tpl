#cloud-config
preserver_hostname: true
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
write_files:
  - path: /etc/sysctl.d/90-kubernetes-cri.conf
    content: |
      net.bridge.bridge-nf-call-iptables = 1
      net.ipv4.ip_forward = 1
      net.bridge.bridge-nf-call-ip6tables = 1
  - path: /etc/modules-load.d/containrd.conf
    content: |
      overlay
      br_netfilter
apt:
  sources:
    kubernetes.list:
      source: 'deb [signed-by=$KEY_FILE] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /'
      # https://stackoverflow.com/questions/72620609/cloud-init-fetch-apt-key-from-remote-file-instead-of-from-a-key-server
      keyid: DE15B14486CD377B9E876E1A234654DA9A296436
      filename: kubernetes.list
package_update: true
package_upgrade: true
packages:
- qemu-guest-agent
- net-tools
- containerd
- kubelet
- kubeadm
- kubectl
runcmd:
    - timedatectl set-timezone America/Toronto
    - systemctl enable qemu-guest-agent
    - systemctl start qemu-guest-agent
    - for i in $(seq 0 ${count-cp - 1}); do sudo bash -c "echo '192.168.0.10$i k8s-cp-$i' >> /etc/hosts"; done
    - for i in $(seq 0 ${count-worker - 1}); do sudo bash -c "echo '192.168.0.11$i k8s-worker-$i' >> /etc/hosts"; done
    - modprobe overlay
    - modprobe br_netfilter
    - apt-mark hold kubelet kubeadm kubectl
    - swapoff -a
    - sysctl --system
    - mkdir -p /etc/containerd
    - containerd config default | tee /etc/containerd/config.toml
    - sed -i 's/            SystemdCgroup = false/            SystemdCgroup = true/' /etc/containerd/config.toml
    - systemctl restart containerd
    - systemctl enable --now kubelet
    - kubeadm config images pull
    - echo "done" > /tmp/cloud-config.done


