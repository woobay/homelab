variable "proxmox_username" {
  type        = string
  description = "Proxmox provider username"
  default     = "root@pam"
}

variable "proxmox_password" {
  type        = string
  description = "Proxmox provider password"
  default     = "notgoodenough"
}

variable "node_names" {
  description = "Name of the proxmox nodes"
  type        = list(string)
  default     = [
    "aramis",
    "athos",
    "porthos"
  ]
}