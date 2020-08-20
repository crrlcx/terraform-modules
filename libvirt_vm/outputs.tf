# Print vm output
output "hostname" {
  value = libvirt_domain.vm.*.network_interface.0.hostname
}

output "ip" {
  value = try(libvirt_domain.vm.*.network_interface.0.addresses.0, "None")
}
