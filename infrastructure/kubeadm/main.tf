locals {
  node_names = {for i in var.node_names: index(var.node_names, i) => i}
}

data "local_file" "ssh_public_key" {
filename = pathexpand("~/.ssh/id_ecdsa.pub")
}

data "template_file" "cp-config" {
  
}
data "template_file" "cp_config" {
  for_each = local.node_names


  template = file("./cloud-init/k8s-node-cp.yaml.tpl")

  vars = {
    ssh_public_key = trimspace(data.local_file.ssh_public_key.content)
    name           = "cp-${each.value}-${each.key}" 
    count-cp       = 1
  }
}

resource "proxmox_virtual_environment_file" "cloud_config_cp" {
  for_each = local.node_names

  content_type = "snippets"
  datastore_id = "local"
  node_name    = "pve1"

  source_raw {
    data      = data.template_file.cp_config.rendered
    file_name = "${each.value.name}.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "control_plane" {
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
    file_id      = proxmox_virtual_environment_cloud_config_cp[each.value].id
    iothread     = true
    discard      = "on"
    size         = 32
    interface = "scsi0"
  }

  network_device {
    bridge = "vmbr0"
  }

}
