source "qemu" "debian-12-latest" {
  iso_url = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.raw"
  iso_checksum = "file:https://cloud.debian.org/images/cloud/bookworm/latest/SHA512SUMS"
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
  ssh_username = "debian"
  ssh_password = "passw0rd"
  qemu_binary = "/usr/libexec/qemu-kvm"
}

build {
  source "qemu.debian-12-latest" {
    vm_name           = "debian-12.raw"
    output_directory  = "builds/localdisk/qemu.debian-12-latest/${formatdate("YYYY-MM-DD-hh", timestamp())}"
  }

  name = "localdisk"

  provisioner "ansible" {
    playbook_file = "${path.root}/ansible/build-local-image.yml"
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
    checksum_types = ["sha256"]
    output = "builds/${build.name}/${source.name}/${formatdate("YYYY-MM-DD-hh", timestamp())}/{{.ChecksumType}}.checksum"                                                                                                                    
  }

  post-processor "manifest" {
    output = "builds/${build.name}/${source.name}/${formatdate("YYYY-MM-DD-hh", timestamp())}/manifest.json"
  }
}
