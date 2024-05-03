# Cluster Installation

## Finish to setup the Control plane

```bash
sudo kubeadm init --pod-network-cidr 192.168.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

curl https://raw.githubusercontent.com/projectcalico/calico/v3.27.3/manifests/calico.yaml -O
kubectl apply -f calico.yaml


kubeadm token create --print-join-command
```


## Step to do on Worker nodes

* Paste result of the kubeadm join with sudo
