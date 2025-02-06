source "qemu" "centos-7-prebaked" {
  iso_url            = "file:///opt/image-base-cache/centos7-base.qcow2"
  iso_checksum       = "sha256:e3e09282906e3a9014ad4692b9d695227fc3fe828c686ead044c76e043510737"
  shutdown_command   = var.root_shutdown_command
  accelerator        = "kvm"
  ssh_username       = "centos"
  ssh_password       = var.gencloud_ssh_password
  ssh_timeout        = var.ssh_timeout
  cpus               = var.cpus
  disk_image         = true
  disk_interface     = "virtio-scsi"
  disk_size          = var.gencloud_disk_size
  disk_cache         = "unsafe"
  disk_discard       = "unmap"
  disk_detect_zeroes = "unmap"
  format             = "raw"
  headless           = var.headless
  memory             = var.memory
  net_device         = "virtio-net"
  qemu_binary        = var.qemu_binary
  cd_files           = ["./cloud-init/meta-data", "./cloud-init/user-data"]
  cd_label           = "cidata"
}

source "qemu" "almalinux-8-latest" {
  iso_url            = "https://repo.almalinux.org/almalinux/8/cloud/x86_64/images/AlmaLinux-8-GenericCloud-UEFI-latest.x86_64.qcow2"
  iso_checksum       = "file:https://repo.almalinux.org/almalinux/8/cloud/x86_64/images/CHECKSUM"
  shutdown_command   = var.root_shutdown_command
  accelerator        = "kvm"
  http_directory     = var.http_directory
  ssh_username       = "almalinux"
  ssh_password       = var.gencloud_ssh_password
  ssh_timeout        = var.ssh_timeout
  cpus               = var.cpus
  disk_image         = true
  disk_interface     = "virtio-scsi"
  disk_size          = var.gencloud_disk_size
  disk_cache         = "unsafe"
  disk_discard       = "unmap"
  disk_detect_zeroes = "unmap"
  format             = "raw"
  headless           = var.headless
  memory             = var.memory
  net_device         = "virtio-net"
  qemu_binary        = var.qemu_binary
  cd_files           = ["./cloud-init/meta-data", "./cloud-init/user-data"]
  cd_label           = "cidata"
}

build {
  source "qemu.centos-7-prebaked" {
    vm_name           = "centos-7.raw"
    output_directory  = "builds/localdisk/qemu.centos-7-prebaked/${formatdate("YYYY-MM-DD-hh", timestamp())}"
  }

  source "qemu.almalinux-8-latest" {
    vm_name           = "almalinux-8.raw"
    output_directory  = "builds/localdisk/qemu.almalinux-8-latest/${formatdate("YYYY-MM-DD-hh", timestamp())}"
  }

  name = "localdisk"

  provisioner "ansible" {
    playbook_file = "${path.root}/ansible/build-local-image.yml"
    extra_arguments = [
      "--skip-tags", "check-requirements,cleanup_ifcfg_files",
      "-e", "sp_inventory_url=http://sp-mgmt.lab.storpool.local",
      "--scp-extra-args", "'-O'"
    ]
    user = "storpool"
    galaxy_file = "${path.root}/ansible/resources.yml"
    roles_path = "${path.root}/ansible/roles/"
  }

  post-processor "checksum" {
    checksum_types = ["sha256"]
    output = "builds/${build.name}/qemu.${source.name}/${formatdate("YYYY-MM-DD-hh", timestamp())}/{{.ChecksumType}}.checksum"
  }

  post-processor "manifest" {
    output = "builds/${build.name}/qemu.${source.name}/${formatdate("YYYY-MM-DD-hh", timestamp())}/manifest.json"
  }
}

