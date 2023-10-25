source "qemu" "pve-8-latest" {
  iso_url = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"
  iso_checksum = "file:https://cloud.debian.org/images/cloud/bookworm/latest/SHA512SUMS"
  format = "raw"
  cpus = 4
  memory = 2048
  disk_image = true
  disk_size = "10G"
  headless = true
  disable_vnc = true
  cd_files = ["./cloud-init/meta-data", "./cloud-init/user-data", "./cloud-init/network-config"]
  cd_label = "cidata"
  shutdown_command  = "echo 'packer' | sudo -S shutdown -P now"
  ssh_username = "debian"
  ssh_password = "passw0rd"
  qemu_binary = "/usr/libexec/qemu-kvm"
}


build {
  source "qemu.pve-8-latest" {
    vm_name           = "pve-8.raw"
    output_directory  = "builds/cloud/qemu.pve-8-latest/${formatdate("YYYY-MM-DD-hh", timestamp())}"
  }

  name = "cloud"

  provisioner "ansible" {
    playbook_file = "${path.root}/ansible/build-iscsi-image.yml"
    extra_arguments = [
      "-vv",
      "--tags",
      "all,proxmox_ve",
      "--skip-tags",
      "check-requirements,cleanup_ifcfg_files,ironic-iscsi",
      "-e",
      "sp_inventory_url=http://sp-mgmt.lab.storpool.local",
      "-e",
      "ansible_ssh_pass=passw0rd",
    ]
    user = "debian"
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
