#Cluster Installation

```bash
cat << EOF | sudo tee /etc/modules-load.d/containrd.conf 
overlay
br_netfilter 
EOF
```
```bash
sudo modprobe overlay
```

```bash
sudo modprobe br_netfilter
```
```bash
cat << EOF | sudo tee /etc/sysctl.d/90-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptales = 1
net.ipv4.ip_forward = 1
net.bridge.brige-nf-call-ip6tables = 1
EOF
```
```bash
sudo sysctl --system
```
```bash
sudo apt-get update && sudo apt-get install -y containerd
```
```bash
sudo mkdir -p /etc/containerd
```
```bash
sudo containerd config default | sudo tee /etc/containerd/config.toml 
sudo systemctl restart containerd
sudo swapoff -a
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
```
```bash
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
```
```bash
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```
```bash
sudo apt-get update 
sudo apt-get install -y kubelet=1.30.0-00 kubeadm=1.30.0-00 kubectl=1.30.0-00
sudo apt-mark hold kubelet kubeadm kubectl
sudo kubeadm init --pod-network-cidr 192.168.0.0/16 --kubernetes-version 1.30.0
```
```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
