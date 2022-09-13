packer {
  required_plugins {
    qemu = {
      version = ">= 1.0.2"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

source "qemu" "ubuntu-1804-latest" {
  iso_url = "https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img"
  iso_checksum = "file:https://cloud-images.ubuntu.com/bionic/current/SHA256SUMS"
  output_directory = "builds/ubuntu-1804-latest"
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
  sources = ["source.qemu.ubuntu-1804-latest"]
  
  provisioner "ansible" {
    playbook_file = "./ansible/build-image.yml"
    extra_arguments = [
      "-vv",
      "--skip-tags",
      "check-requirements",
      "-e",
      "sp_inventory_url=http://sp-mgmt.lab.storpool.local",
    ]
    user = "ubuntu"
    galaxy_file = "./ansible/resources.yml"
    galaxy_force_install = true
    roles_path = "./ansible/roles/"
  }
}
