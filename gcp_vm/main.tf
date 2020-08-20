# Versions
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.0"
    }
  }
  required_version = ">= 0.13"
}

# Provider
provider "google" {
  credentials = var.gcp_creds
  // credentials = file(var.gcp_creds_file)
  project = var.gcp_project_id
  region  = var.gcp_project_region
}

# Data Sources
data "google_compute_image" "boot_image" {
  project = var.gcp_vm_boot_image != "" ? var.gcp_vm_boot_image_project : "ubuntu-os-cloud"
  name    = var.gcp_vm_boot_image != "" ? var.gcp_vm_boot_image : "ubuntu-minimal-2004-focal-v20200501"
}
data "google_compute_image" "boot_image_family" {
  project = var.gcp_vm_boot_image_family != "" ? var.gcp_vm_boot_image_project : "ubuntu-os-cloud"
  family  = var.gcp_vm_boot_image_family != "" ? var.gcp_vm_boot_image_family : "ubuntu-minimal-2004-lts"
}

# Create system disk from image
resource "google_compute_disk" "gcp_vm_boot" {
  count = var.gcp_vm_count
  zone  = var.gcp_vm_zones[count.index % length(var.gcp_vm_zones)]

  name = "${var.gcp_vm_prefix}${format("%02d", count.index + 1)}${var.gcp_vm_boot_suffix}"

  image                     = var.gcp_vm_boot_image != "" ? data.google_compute_image.boot_image.self_link : data.google_compute_image.boot_image_family.self_link
  physical_block_size_bytes = 4096
  size                      = var.gcp_vm_boot_size
  type                      = var.gcp_vm_boot_type

  project = var.gcp_project_id

  lifecycle {
    create_before_destroy = true
  }
}

# Create attached disk for data
resource "google_compute_disk" "gcp_vm_attached" {
  count = var.gcp_vm_attached_size > 0 ? var.gcp_vm_count : 0
  zone  = var.gcp_vm_zones[count.index % length(var.gcp_vm_zones)]

  name = "${var.gcp_vm_prefix}${format("%02d", count.index + 1)}${var.gcp_vm_attached_suffix}"

  physical_block_size_bytes = 4096
  size                      = var.gcp_vm_attached_size
  type                      = var.gcp_vm_attached_type

  project = var.gcp_project_id

  lifecycle {
    create_before_destroy = true
  }
}

# Create internal ip
resource "google_compute_address" "gcp_vm_internal_ip" {
  count = length(var.gcp_vm_ip_base) != 0 ? var.gcp_vm_count : 0

  name = "${var.gcp_vm_prefix}${format("%02d", count.index + 1)}-internal"

  address      = "${var.gcp_project_ip_base}.${var.gcp_vm_ip_base + count.index + 1}"
  address_type = "INTERNAL"
  purpose      = "GCE_ENDPOINT"
  subnetwork   = var.gcp_project_subnetwork

  project = var.gcp_project_id
  region  = var.gcp_project_region

  lifecycle {
    create_before_destroy = true
  }
}

# Create external ip
resource "google_compute_address" "gcp_vm_external_ip" {
  count = var.gcp_vm_need_external_ip ? var.gcp_vm_count : 0

  name = "${var.gcp_vm_prefix}${format("%02d", count.index + 1)}-external"

  address_type = "EXTERNAL"
  network_tier = "PREMIUM"

  project = var.gcp_project_id
  region  = var.gcp_project_region

  lifecycle {
    create_before_destroy = true
  }
}

# Create GCP instance
resource "google_compute_instance" "gcp_vm" {
  count = var.gcp_vm_count
  zone  = var.gcp_vm_zones[count.index % length(var.gcp_vm_zones)]

  name = "${var.gcp_vm_prefix}${format("%02d", count.index + 1)}"

  allow_stopping_for_update = var.gcp_vm_allow_stopping_for_update
  can_ip_forward            = var.gcp_vm_can_ip_forward
  deletion_protection       = var.gcp_vm_deletion_protection
  enable_display            = var.gcp_vm_enable_display
  machine_type              = var.gcp_vm_machine_type
  tags                      = var.gcp_vm_network_tags

  project = var.gcp_project_id

  network_interface {
    network_ip         = length(var.gcp_vm_ip_base) != 0 ? google_compute_address.gcp_vm_internal_ip[count.index].address : "null"
    network            = var.gcp_project_network
    subnetwork         = var.gcp_project_subnetwork
    subnetwork_project = var.gcp_project_id

    dynamic "access_config" {
      for_each = slice(
        [
          {
            // we set null but it will never reached because the slice with 0 cut it off
            "external_ip" = var.gcp_vm_need_external_ip ? google_compute_address.gcp_vm_external_ip[count.index].address : "null"
          },
      ], 0, var.gcp_vm_need_external_ip ? 1 : 0)
      content {
        nat_ip       = access_config.value.external_ip
        network_tier = "PREMIUM"
      }
    }
  }

  boot_disk {
    auto_delete = false
    device_name = element(google_compute_disk.gcp_vm_boot.*.name, count.index)
    mode        = "READ_WRITE"
    source      = element(google_compute_disk.gcp_vm_boot.*.self_link, count.index)
  }

  // handle attached disk
  dynamic "attached_disk" {
    for_each = slice(
      [
        {
          // we set null but it will never reached because the slice with 0 cut it off
          "attached_name"      = var.gcp_vm_attached_size > 0 ? element(google_compute_disk.gcp_vm_attached.*.name, count.index) : "null"
          "attached_self_link" = var.gcp_vm_attached_size > 0 ? element(google_compute_disk.gcp_vm_attached.*.self_link, count.index) : "null"
        },
    ], 0, var.gcp_vm_attached_size > 0 ? 1 : 0)
    content {
      device_name = attached_disk.value.attached_name
      source      = attached_disk.value.attached_self_link
      mode        = "READ_WRITE"
    }
  }

  service_account {
    email = var.gcp_project_service_account
    scopes = [
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/trace.append"
    ]
  }

  scheduling {
    automatic_restart   = "true"
    on_host_maintenance = "MIGRATE"
    preemptible         = "false"
  }

  lifecycle {
    create_before_destroy = true
  }

}
