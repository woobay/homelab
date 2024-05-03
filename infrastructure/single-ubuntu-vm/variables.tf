variable "proxmox_username" {
  type = string
  description = "Proxmox provider username"
  default = "root@pam"
}

variable "proxmox_password" {
  type = string
  description = "Proxmox provider password"
  default = "notgoodenough"
}
