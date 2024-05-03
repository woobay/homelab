locals {
  k8s_nodes_map = merge(
    {
      for idx in range(var.cp_count) : "cp-${idx}" => {
        name         = "${var.vm_name_prefix}-cp-${idx}"
        cp           = true
        count-cp     = var.cp_count
        count-worker = var.worker_count
        address      = "192.168.0.${100 + idx}/24"
      }
    },
    {
      for idx in range(var.worker_count) : "worker-${idx}" => {
        name         = "${var.vm_name_prefix}-worker-${idx}"
        cp           = false
        count-cp     = var.cp_count
        count-worker = var.worker_count
        address      = "192.168.0.${110 + idx}/24"
      }
    }
  )
}

data "local_file" "ssh_public_key" {
  filename = pathexpand("~/.ssh/id_rsa.pub")

}

data "template_file" "cloud_config" {
  for_each = local.k8s_nodes_map


  template = each.value.cp ? file("./cloud-init/k8s-node-cp.yaml.tpl") : file("./cloud-init/k8s-node-worker.yaml.tpl")

  vars = {
    ssh_public_key = trimspace(data.local_file.ssh_public_key.content)
    name           = each.value.name
    count-cp       = each.value.count-cp
    count-worker   = each.value.count-worker
    address        = each.value.address
  }
}

resource "proxmox_virtual_environment_file" "cloud_config" {
  for_each = local.k8s_nodes_map

  content_type = "snippets"
  datastore_id = "local"
  node_name    = "homelab"

  source_raw {
    data      = data.template_file.cloud_config[each.key].rendered
    file_name = "${each.value.name}.yaml"
  }
}


resource "proxmox_virtual_environment_vm" "this" {
  for_each = local.k8s_nodes_map

  name      = each.value.name
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
        address = each.value.address
        gateway = "192.168.0.1"
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.cloud_config[each.key].id
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

