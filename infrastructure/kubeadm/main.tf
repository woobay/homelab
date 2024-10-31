locals {
  node_names = {for i in var.node_names: index(var.node_names, i) => i}
}

data "local_file" "ssh_public_key" {
filename = pathexpand("~/.ssh/id_rsa.pub")
}

data "template_file" "cp_config" {
  for_each = local.node_names


  template = file("./cloud-init/k8s-node-cp.yaml.tpl")

  vars = {
    ssh_public_key = trimspace(data.local_file.ssh_public_key.content)
    name           = "cp-${each.value}-${each.key}" 
    count-cp       = 3
    count-worker = 3
  }
}
data "template_file" "worker_config" {
  for_each = local.node_names


  template = file("./cloud-init/k8s-node-worker.yaml.tpl")

  vars = {
    ssh_public_key = trimspace(data.local_file.ssh_public_key.content)
    name           = "worker-${each.value}-${each.key}" 
    count-cp       = 1
    count-worker = 1
  }
}

resource "proxmox_virtual_environment_file" "cloud_config_cp" {
  for_each = local.node_names

  content_type = "snippets"
  datastore_id = "local"
  node_name    = each.value

  source_raw {
    data      = data.template_file.cp_config[each.key].rendered
    file_name = "cp-${each.value}-${each.key}.yaml"
  }
}
resource "proxmox_virtual_environment_file" "cloud_config_worker" {
  for_each = local.node_names

  content_type = "snippets"
  datastore_id = "local"
  node_name    = each.value

  source_raw {
    data      = data.template_file.worker_config[each.key].rendered
    file_name = "worker-${each.value}-${each.key}.yaml"
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
  user_data_file_id = proxmox_virtual_environment_file.cloud_config_cp[each.key].id
  }
  
  cpu {
    cores = 4
  }

  memory {
    dedicated = 8192
  }

  agent {
    enabled = true
  }
 disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_download_file.ubuntu_cloud_image[each.key].id
    iothread     = true
    discard      = "on"
    size         = 32
    interface = "scsi0"
  }

  network_device {
    bridge = "vmbr0"
  }
}
resource "proxmox_virtual_environment_vm" "worker" {
  for_each = local.node_names
  name      = "worker-${each.value}-${each.key}"
  node_name = each.value

  initialization {
    ip_config {
      ipv4 {
        address = "192.168.0.9${each.key}/24"
        gateway = "192.168.0.1"
      }
    }
  user_data_file_id = proxmox_virtual_environment_file.cloud_config_worker[each.key].id
  }
  
  cpu {
    cores = 2
  }

  memory {
    dedicated = 4096
  }

  agent {
    enabled = true
  }
 disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_download_file.ubuntu_cloud_image[each.key].id
    iothread     = true
    discard      = "on"
    size         = 32
    interface = "scsi0"
  }

  network_device {
    bridge = "vmbr0"
  }
}

resource "proxmox_virtual_environment_download_file" "ubuntu_cloud_image" {
  for_each = local.node_names
  content_type = "iso"
  datastore_id = "local"
  node_name    = each.value

  url = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
}


####### HA PROXY

data "template_file" "haproxy_config" {
  template = file("./cloud-init/haproxy.yaml.tpl")

  vars = {
    ssh_public_key = trimspace(data.local_file.ssh_public_key.content)
    name           = "k8s-haproxy"
  }
}

resource "proxmox_virtual_environment_file" "cloud_config_haproxy" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "porthos"  # adjust this to your Proxmox node name

  source_raw {
    data      = data.template_file.haproxy_config.rendered
    file_name = "haproxy.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "haproxy" {
  name        = "k8s-haproxy"
  node_name   = "porthos"  # adjust this to your Proxmox node name

  initialization {
    datastore_id = "local"
    ip_config {
      ipv4 {
        address = "192.168.0.70/24"
        gateway = "192.168.0.1"
      }
    }
    user_data_file_id = proxmox_virtual_environment_file.cloud_config_haproxy.id
  }
  
  cpu {
    cores = 2
    type  = "host"
  }

  memory {
    dedicated = 2048
  }

  agent {
    enabled = true
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_download_file.ubuntu_cloud_image[2].id
    iothread     = true
    discard      = "on"
    size         = 20
    interface    = "scsi0"
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  operating_system {
    type = "l26"
  }
}