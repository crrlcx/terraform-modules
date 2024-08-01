# terraform-modules

Terraform modules to include in terraform project

[[_TOC_]]

## libvirt_vm

Module creates a Qemu-KVM virtual machine via Libvirt.  
Require terraform provider [dmacvicar/libvirt](https://github.com/dmacvicar/terraform-provider-libvirt)  
[README](libvirt/readme.md)

## gcp_vm

Module creates a Google Cloud virtual machine.  
[README](gcp/readme.md)

## aws_route53_csv

Module creates a AWS Route53 zone from a CSV files.  
[README](aws/readme.md)
