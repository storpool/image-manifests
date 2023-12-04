source "qemu" "ubuntu-1804-latest" {
  iso_url = "https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img"
  iso_checksum = "file:https://cloud-images.ubuntu.com/bionic/current/SHA256SUMS"
  format = "raw"
  cpus = 4
  memory = 2048
  disk_image = true
  disk_size = "5G"
  headless = true
  disable_vnc = true
  cd_files = ["./cloud-init/meta-data", "./cloud-init/user-data"]
  cd_label = "cidata"
  shutdown_command  = "echo 'packer' | sudo -S shutdown -P now"
  ssh_username = "ubuntu"
  ssh_password = "passw0rd"
  qemu_binary = "/usr/libexec/qemu-kvm"
}

source "qemu" "ubuntu-2004-latest" {
  iso_url = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img"
  iso_checksum = "file:https://cloud-images.ubuntu.com/focal/current/SHA256SUMS"
  format = "raw"
  cpus = 4
  memory = 2048
  disk_image = true
  disk_size = "5G"
  headless = true
  disable_vnc = true
  cd_files = ["./cloud-init/meta-data", "./cloud-init/user-data"]
  cd_label = "cidata"
  shutdown_command  = "echo 'packer' | sudo -S shutdown -P now"
  ssh_username = "ubuntu"
  ssh_password = "passw0rd"
  qemu_binary = "/usr/libexec/qemu-kvm"
}

source "qemu" "ubuntu-2204-latest" {
  iso_url = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  iso_checksum = "file:https://cloud-images.ubuntu.com/jammy/current/SHA256SUMS"
  format = "raw"
  cpus = 4
  memory = 2048
  disk_image = true
  disk_size = "5G"
  headless = true
  disable_vnc = true
  cd_files = ["./cloud-init/meta-data", "./cloud-init/user-data"]
  cd_label = "cidata"
  shutdown_command  = "echo 'packer' | sudo -S shutdown -P now"
  ssh_username = "ubuntu"
  ssh_password = "passw0rd"
  qemu_binary = "/usr/libexec/qemu-kvm"
}

build {
  source "qemu.ubuntu-1804-latest" {
    vm_name           = "ubuntu-1804.raw"
    output_directory  = "builds/iscsi/qemu.ubuntu-1804-latest/${formatdate("YYYY-MM-DD-hh", timestamp())}"
  }

  source "qemu.ubuntu-2004-latest" {
    vm_name           = "ubuntu-2004.raw"
    output_directory  = "builds/iscsi/qemu.ubuntu-2004-latest/${formatdate("YYYY-MM-DD-hh", timestamp())}"
  }

  source "qemu.ubuntu-2204-latest" {
    vm_name           = "ubuntu-2204.raw"
    output_directory  = "builds/iscsi/qemu.ubuntu-2204-latest/${formatdate("YYYY-MM-DD-hh", timestamp())}"
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
    output = "builds/${build.name}/${source.name}/${formatdate("YYYY-MM-DD-hh", timestamp())}/{{.ChecksumType}}.checksum"                                                                                                                    
  }

  post-processor "manifest" {
    output = "builds/${build.name}/${source.name}/${formatdate("YYYY-MM-DD-hh", timestamp())}/manifest.json"
  }
}

build {
  source "qemu.ubuntu-1804-latest" {
    vm_name           = "ubuntu-1804.raw"
    output_directory  = "builds/cloud/qemu.ubuntu-1804-latest/${formatdate("YYYY-MM-DD-hh", timestamp())}"
  }

  source "qemu.ubuntu-2004-latest" {
    vm_name           = "ubuntu-2004.raw"
    output_directory  = "builds/cloud/qemu.ubuntu-2004-latest/${formatdate("YYYY-MM-DD-hh", timestamp())}"
  }

  source "qemu.ubuntu-2204-latest" {
    vm_name           = "ubuntu-2204.raw"
    output_directory  = "builds/cloud/qemu.ubuntu-2204-latest/${formatdate("YYYY-MM-DD-hh", timestamp())}"
  }

  name = "cloud"

  provisioner "ansible" {
    playbook_file = "${path.root}/ansible/build-iscsi-image.yml"
    extra_arguments = [
      "-vv",
      "--skip-tags",
      "check-requirements,cleanup_ifcfg_files,ironic,ironic-iscsi",
      "-e",
      "sp_inventory_url=http://sp-mgmt.lab.storpool.local",
    ]
    user = "storpool"
    galaxy_file = "${path.root}/ansible/resources.yml"
    roles_path = "${path.root}/ansible/roles/"
  }

  post-processor "checksum" {
    checksum_types = ["md5", "sha256"]
    output = "builds/${build.name}/${source.name}/${formatdate("YYYY-MM-DD-hh", timestamp())}/{{.ChecksumType}}.checksum"                                                                                                                    
  }

  post-processor "manifest" {
    output = "builds/${build.name}/${source.name}/${formatdate("YYYY-MM-DD-hh", timestamp())}/manifest.json"
  }
}

build {
  source "qemu.ubuntu-2004-latest" {
    vm_name           = "ubuntu-2004-${formatdate("YYYYMMDD", timestamp())}.img"
    output_directory  = "builds/ubuntu-2004-nodepool"
  }

  name = "nodepool"

  provisioner "ansible" {
    playbook_file = "${path.root}/ansible/build-nodepool-image.yml"
    extra_arguments = [
      "-vv",
      "--skip-tags",
      "check-requirements"
    ]
    user = "ubuntu"
    groups = ["storpool_block"]
    galaxy_file = "${path.root}/ansible/resources.yml"
    roles_path = "${path.root}/ansible/roles/"
  }

  post-processor "checksum" {
    checksum_types = ["sha512"]
    output = "builds/ubuntu-2004-nodepool/${build.name}-${source.name}-{{.ChecksumType}}.checksum"
  }

  post-processor "manifest" {
    output = "builds/ubuntu-2004-nodepool/${build.name}-${source.name}-manifest.json"
  }
}

build {
  source "qemu.ubuntu-2204-latest" {
    vm_name           = "ubuntu-2204-${formatdate("YYYYMMDD", timestamp())}.img"
    output_directory  = "builds/ubuntu-2204-nodepool"
  }

  name = "nodepool"

  provisioner "ansible" {
    playbook_file = "${path.root}/ansible/build-nodepool-image.yml"
    extra_arguments = [
      "-vv",
      "--skip-tags",
      "check-requirements"
    ]
    user = "ubuntu"
    groups = ["storpool_block"]
    galaxy_file = "${path.root}/ansible/resources.yml"
    roles_path = "${path.root}/ansible/roles/"
  }

  post-processor "checksum" {
    checksum_types = ["sha512"]
    output = "builds/ubuntu-2204-nodepool/${build.name}-${source.name}-{{.ChecksumType}}.checksum"
  }

  post-processor "manifest" {
    output = "builds/ubuntu-2204-nodepool/${build.name}-${source.name}-manifest.json"
  }
}

