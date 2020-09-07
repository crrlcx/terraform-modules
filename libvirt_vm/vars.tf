# Project
variable "ip_base" {
  default = null
}
variable "ips" {
  default = null
}
variable "project" {
  default = null
}
variable "network_id" {
  default = null
}
variable "pool" {
  default = null
}

# Base pool and volumes
variable "base_pool" {
  default = null
}
variable "base_volume_boot" {
  default = null
}
variable "base_volume_system" {
  default = null
}

# Default vm variables
variable "vm_autostart" {
  default = false
}
variable "vm_count" {
  default = 0
}
variable "vm_data_size" {
  default = 0
}
variable "vm_ip_base" {
  default = 0
}
variable "vm_memory" {
  default = 512
}
variable "vm_prefix" {
  default = "vm-"
}
variable "vm_running" {
  default = false
}
variable "vm_vcpu" {
  default = 1
}
