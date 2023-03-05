# versions
terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.7.0"
    }
  }
  required_version = "~> 1.3.0"
}

# Create images from templates
resource "libvirt_volume" "vm_boot" {
  count = var.vm_count
  name  = "${var.vm_prefix}${format("%02d", count.index + 1)}-boot.qcow2"

  base_volume_name = var.base_volume_boot
  base_volume_pool = var.base_pool
  format           = "qcow2"
  pool             = var.pool

  lifecycle {
    create_before_destroy = false
  }
}

resource "libvirt_volume" "vm_system" {
  count = var.vm_count
  name  = "${var.vm_prefix}${format("%02d", count.index + 1)}-system.qcow2"

  base_volume_name = var.base_volume_system
  base_volume_pool = var.base_pool
  format           = "qcow2"
  pool             = var.pool

  lifecycle {
    create_before_destroy = false
  }
}

resource "libvirt_volume" "vm_data" {
  count = var.vm_data_size > 0 ? var.vm_count : 0
  name  = "${var.vm_prefix}${format("%02d", count.index + 1)}-data.qcow2"

  format = "qcow2"
  pool   = var.pool
  size   = var.vm_data_size

  lifecycle {
    create_before_destroy = false
  }
}

# Create domain
resource "libvirt_domain" "vm" {
  count = var.vm_count
  name  = "${var.vm_prefix}${format("%02d", count.index + 1)}.${var.project}"

  autostart  = var.vm_autostart
  emulator   = "/usr/bin/kvm"
  firmware   = "/usr/share/OVMF/OVMF_CODE.fd"
  machine    = "q35"
  memory     = var.vm_memory
  qemu_agent = true
  running    = var.vm_running
  vcpu       = var.vm_vcpu

  cpu {
    mode = "host-model"
  }

  network_interface {
    addresses      = coalesce(var.vm_ip_base, 255) == 255 ? null : ["${var.ip_base}.${var.vm_ip_base + count.index + 1}"]
    hostname       = "${var.vm_prefix}${format("%02d", count.index + 1)}.${var.project}"
    network_id     = var.network_id
    wait_for_lease = true
  }

  console {
    target_port = "0"
    target_type = "serial"
    type        = "pty"
  }

  boot_device {
    dev = ["hd", "network"]
  }

  dynamic "disk" {
    for_each = [
      {
        "vol_id" = element(libvirt_volume.vm_boot.*.id, count.index)
      },
      {
        "vol_id" = element(libvirt_volume.vm_system.*.id, count.index)
      },
    ]
    content {
      scsi      = "true"
      volume_id = disk.value.vol_id
    }
  }

  // handle additional disks
  dynamic "disk" {
    for_each = slice(
      [
        {
          // we set null but it will never reached because the slice with 0 cut it off
          "voldata_id" = var.vm_data_size > 0 ? element(libvirt_volume.vm_data.*.id, count.index) : "null"
        },
    ], 0, var.vm_data_size > 0 ? 1 : 0)
    content {
      scsi      = "true"
      volume_id = disk.value.voldata_id
    }
  }

  video {
    type = "virtio"
  }

  graphics {
    autoport    = true
    listen_type = "address"
    type        = "vnc"
  }

  lifecycle {
    create_before_destroy = false
  }

  // provisioner "local-exec" {
  //   command = "./check_health.sh ${self.ipv4_address}"
  // }
}
