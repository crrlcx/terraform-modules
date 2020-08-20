# Provider variables
variable "gcp_creds" {
  default = null
}
// variable "gcp_creds_file" {
//   default = "resources/google_account.json"
// }

# Project variables
variable "gcp_project_id" {
  default = null
}
variable "gcp_project_region" {
  default = "us-west1"
}
variable "gcp_project_ip_base" {
  default = null
}
variable "gcp_project_network" {
  default = null
}
variable "gcp_project_service_account" {
  default = null
}
variable "gcp_project_subnetwork" {
  default = null
}

# Default vm disk variables
variable "gcp_vm_attached_size" {
  default = 0
}
variable "gcp_vm_attached_suffix" {
  default = "-data"
}
variable "gcp_vm_attached_type" {
  default = "pd-ssd"
}
variable "gcp_vm_boot_image" {
  default = ""
}
variable "gcp_vm_boot_image_family" {
  default = ""
}
variable "gcp_vm_boot_image_project" {
  default = "ubuntu-os-cloud"
}
variable "gcp_vm_boot_size" {
  default = 10
}
variable "gcp_vm_boot_suffix" {
  default = "-system"
}
variable "gcp_vm_boot_type" {
  default = "pd-standard"
}

# Default vm variables
variable "gcp_vm_allow_stopping_for_update" {
  default = false
}
variable "gcp_vm_can_ip_forward" {
  default = false
}
variable "gcp_vm_count" {
  default = 0
}
variable "gcp_vm_deletion_protection" {
  default = false
}
variable "gcp_vm_enable_display" {
  default = false
}
variable "gcp_vm_ip_base" {
  default = 0
}
variable "gcp_vm_machine_type" {
  default = "e2-small"
}
variable "gcp_vm_need_external_ip" {
  default = false
}
variable "gcp_vm_network_tags" {
  default = []
}
variable "gcp_vm_prefix" {
  default = "vm-"
}
variable "gcp_vm_zones" {
  default = ["us-west1-a", "us-west1-b", "us-west1-c"]
}
