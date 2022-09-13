variables {
  //
  // common variables
  //
  iso_url_8_x86_64       = "https://repo.almalinux.org/almalinux/8.6/isos/x86_64/AlmaLinux-8.6-x86_64-boot.iso"
  iso_checksum_8_x86_64  = "file:https://repo.almalinux.org/almalinux/8.6/isos/x86_64/CHECKSUM"
  iso_url_9_x86_64       = "https://repo.almalinux.org/almalinux/9.0/isos/x86_64/AlmaLinux-9.0-x86_64-boot.iso"
  iso_checksum_9_x86_64  = "file:https://repo.almalinux.org/almalinux/9.0/isos/x86_64/CHECKSUM"
  headless               = true
  boot_wait              = "10s"
  cpus                   = 2
  memory                 = 2048
  post_cpus              = 1
  post_memory            = 1024
  http_directory         = "http"
  ssh_timeout            = "3600s"
  root_shutdown_command  = "echo 'packer' | sudo -S shutdown -P now"
  qemu_binary            = ""
  //
  // Generic Cloud (OpenStack) variables
  //
  el_7_boot_command = [
    "<tab> inst.text inst.gpt net.ifnames=0 inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/centos-7.ks<enter><wait>"
  ]
  el_8_boot_command = [
    "<tab> inst.text inst.gpt net.ifnames=0 inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/almalinux-8.ks<enter><wait>"
  ]
  el_9_boot_command = [
    "<tab> inst.text inst.gpt net.ifnames=0 inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/almalinux-9.ks<enter><wait>"
  ]
  gencloud_disk_size         = "10G"
  gencloud_ssh_username      = "storpool"
  gencloud_ssh_password      = "passw0rd"
}