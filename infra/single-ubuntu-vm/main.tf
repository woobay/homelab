resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
  name      = "ubuntu-img"
  node_name = "homelab"

  initialization {

    ip_config {
      ipv4 {
        address = "192.168.0.222/24"
        gateway = "192.168.0.1"
      }
    }

  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_download_file.ubuntu_cloud_image.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 20
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
