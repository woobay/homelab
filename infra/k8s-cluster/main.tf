data "local_file" "ssh_public_key" {
  filename = pathexpand("~/.ssh/id_rsa.pub")

}

data "template_file" "cloud_config" {
  template = file("./cloud-init/k8s-node.yaml.tpl")

  vars = {
    ssh_public_key = trimspace(data.local_file.ssh_public_key.content)

  }
}

resource "proxmox_virtual_environment_file" "cloud_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "homelab"

  source_raw {
    data      = data.template_file.cloud_config.rendered
    file_name = "cloud-config.yaml"
  }
}


resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
  name      = "vm-cluster-ubuntu"
  node_name = "homelab"

  agent {
    enabled = true
  }

  cpu {
    cores = 4
  }

  memory {
    dedicated = 8192
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_download_file.ubuntu_cloud_image.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 20
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.cloud_config.id
  }

  network_device {
    bridge = "vmbr0"
  }

}

resource "proxmox_virtual_environment_download_file" "ubuntu_cloud_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "homelab"

  url = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
}

output "vm_ipv4_address" {
  value = proxmox_virtual_environment_vm.ubuntu_vm.ipv4_addresses[1][0]
}
