locals {
  node_names = {for i in var.node_names: index(var.node_names, i) => i}
}

resource "proxmox_virtual_environment_vm" "talos-cp" {
  for_each = local.node_names
  name      = "cp-${each.value}-${each.key}"
  node_name = each.value

  initialization {
    ip_config {
      ipv4 {
        address = "192.168.0.8${each.key}/24"
        gateway = "192.168.0.1"
      }
    }
  }
  
  cpu {
    cores = 4
  }

  memory {
    dedicated = 4096
  }

  agent {
    enabled = true
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_file.nocloud[each.value].id
    iothread     = true
    discard      = "on"
    size         = 32
    interface = "scsi0"
  }

  network_device {
    bridge = "vmbr0"
  }

}


resource "proxmox_virtual_environment_vm" "talos-worker" {
  for_each = local.node_names
  name      = "worker-${each.value}-${each.key}"
  node_name = each.value

  initialization {
    ip_config {
      ipv4 {
        address = "192.168.0.8${each.key}/24"
        gateway = "192.168.0.1"
      }
    }
  }
  
  cpu {
    cores = 2
  }

  memory {
    dedicated = 2048
  }

  agent {
    enabled = true
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_file.nocloud[each.value].id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 32
  }

  network_device {
    bridge = "vmbr0"
  }

}


resource "proxmox_virtual_environment_file" "nocloud" {
  for_each = toset(var.node_names)

  content_type = "iso"
  datastore_id = "local"
  node_name    = each.key

  source_file {
    path = "https://factory.talos.dev/image/ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515/v1.7.6/nocloud-amd64.iso"
  }
} 
