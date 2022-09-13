source "qemu" "centos-7-kickstart" {
  iso_url            = "http://mirrors.neterra.net/centos/7.9.2009/isos/x86_64/CentOS-7-x86_64-Minimal-2009.iso"
  iso_checksum       = "file:http://mirrors.neterra.net/centos/7.9.2009/isos/x86_64/sha256sum.txt"
  shutdown_command   = var.root_shutdown_command
  accelerator        = "kvm"
  http_directory     = var.http_directory
  ssh_username       = var.gencloud_ssh_username
  ssh_password       = var.gencloud_ssh_password
  ssh_timeout        = var.ssh_timeout
  cpus               = var.cpus
  disk_interface     = "virtio-scsi"
  disk_size          = var.gencloud_disk_size
  disk_cache         = "unsafe"
  disk_discard       = "unmap"
  disk_detect_zeroes = "unmap"
  disk_compression   = true
  format             = "raw"
  headless           = var.headless
  memory             = var.memory
  net_device         = "virtio-net"
  qemu_binary        = var.qemu_binary
  boot_wait          = var.boot_wait
  boot_command       = var.el_7_boot_command
}

source "qemu" "almalinux-8-kickstart" {
  iso_url            = "https://repo.almalinux.org/almalinux/8.6/isos/x86_64/AlmaLinux-8.6-x86_64-boot.iso"
  iso_checksum       = "file:https://repo.almalinux.org/almalinux/8.6/isos/x86_64/CHECKSUM"
  shutdown_command   = var.root_shutdown_command
  accelerator        = "kvm"
  http_directory     = var.http_directory
  ssh_username       = var.gencloud_ssh_username
  ssh_password       = var.gencloud_ssh_password
  ssh_timeout        = var.ssh_timeout
  cpus               = var.cpus
  disk_interface     = "virtio-scsi"
  disk_size          = var.gencloud_disk_size
  disk_cache         = "unsafe"
  disk_discard       = "unmap"
  disk_detect_zeroes = "unmap"
  disk_compression   = true
  format             = "raw"
  headless           = var.headless
  memory             = var.memory
  net_device         = "virtio-net"
  qemu_binary        = var.qemu_binary
  boot_wait          = var.boot_wait
  boot_command       = var.el_8_boot_command
}

build {
  source "qemu.centos-7-kickstart" {
    vm_name           = "iscsi-centos-7-${formatdate("YYYYMMDD", timestamp())}.img"
    output_directory  = "builds/el"
  }

  source "qemu.almalinux-8-kickstart" {
    vm_name           = "iscsi-almalinux-8-${formatdate("YYYYMMDD", timestamp())}.img"
    output_directory  = "builds/el"
  }

  name = "iscsi"

  provisioner "ansible" {
    playbook_file = "${path.root}/ansible/build-iscsi-image.yml"
    extra_arguments = [
      "-vv",
      "--skip-tags",
      "check-requirements,cleanup_ifcfg_files",
      "-e",
      "sp_inventory_url=http://sp-mgmt.lab.storpool.local",
    ]
    user = "storpool"
    galaxy_file = "${path.root}/ansible/resources.yml"
    roles_path = "${path.root}/ansible/roles/"
  }

  post-processor "checksum" {
    checksum_types = ["md5", "sha256"]
    output = "builds/el/${build.name}-${source.name}-{{.ChecksumType}}.checksum"
  }

  post-processor "manifest" {
    output = "builds/el/${build.name}-${source.name}-manifest.json"
  }
}

