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

variable "cp_count" {
  type        = number
  description = "Number of K8s control plane nodes"
  default     = 1
}

variable "worker_count" {
  type        = number
  description = "Number of k8s worker nodes"
  default     = 2
}

variable "vm_name_prefix" {
  type        = string
  description = "Prefix for naming k8s"
  default     = "k8s"
}
