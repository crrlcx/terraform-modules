# Print vm output
output "gcp_vm_boot__self_link" {
  description = "Print instance system disk link"
  value       = google_compute_disk.gcp_vm_boot.*.self_link
}

output "gcp_vm_attached__self_link" {
  description = "Print instance additional disk link"
  value       = google_compute_disk.gcp_vm_attached.*.self_link
}

output "gcp_vm__self_link" {
  description = "Print instance link"
  value       = google_compute_instance.gcp_vm.*.self_link
}

output "gcp_vm_name" {
  description = "Print instance hostname"
  value       = google_compute_instance.gcp_vm.*.name
}

output "gcp_vm_zone" {
  description = "Print instance aviability zone"
  value       = google_compute_instance.gcp_vm.*.zone
}

output "gcp_vm_internal_ip" {
  description = "Print instance local ip address"
  value       = google_compute_address.gcp_vm_internal_ip.*.address
}

output "gcp_vm_external_ip" {
  description = "Print instance global ip address"
  value       = google_compute_address.gcp_vm_external_ip.*.address
}
