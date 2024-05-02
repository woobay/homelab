# Homelab

Projet to remake my homelab using proxmox/terraform/k8s

    - cat << EOF | sudo tee /etc/modules-load.d/containrd.conf 
    overlay
    br_netfilter 
    EOF
    - sudo modprobe overlay
    - sudo modprobe br_netfilter
    - cat << EOF | sudo tee /etc/sysctl.d/90-kubernetes-cri.conf
    net.bridge.bridge-nf-call-iptales = 1
    net.ipv4.ip_forward = 1
    net.bridge.brige-nf-call-ip6tables = 1
    EOF
    - sudo sysctl --system
    - sudo apt-get update && sudo apt-get install -y containerd
    - sudo mkdir -p /etc/containerd
    - sudo containerd config default | sudo tee /etc/containerd/config.toml 
    - sudo systemctl restart containerd
    - sudo swapoff -a
    - sudo apt-get update && sudo apt-get install -y apt-transport-https curl
    - curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo pat-key add -
    - cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
    deb https://apt.kubernetes.io/ kubernetes-xenial main
    EOF
    - sudo apt-get update 
    - sudo apt-get install -y kubelet=1.30.0-00 kubeadm=1.30.0-00 kubectl=1.30.0-00
    - sudo apt-mark hold kubelet kubeadm kubectl
    - sudo kubeadm init --pod-network-cidr 192.168.0.0/16 --kubernetes-version 1.30.0
    - mkdir -p $HOME/.kube
    - sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    - sudo chown $(id -u):$(id -g) $HOME/.kube/config


## 2024-05-01
* Started creating the infra for the cluster with Terraform
* Setup basic vm with terraform 

## 2024-04-11
* Setup Proxmox 
* Setup TrueNas
* Setup Jellyfin
