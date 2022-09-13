variables {
  //
  // common variables
  //
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
    "<tab> inst.text inst.gpt net.ifnames=0 inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/enterprise-linux-7.ks<enter><wait>"
  ]
  el_8_boot_command = [
    "<tab> inst.text inst.gpt net.ifnames=0 inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/enterprise-linux-8.ks<enter><wait>"
  ]
  el_9_boot_command = [
    "<tab> inst.text inst.gpt net.ifnames=0 inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/almalinux-9.ks<enter><wait>"
  ]
  gencloud_disk_size         = "10G"
  gencloud_ssh_username      = "storpool"
  gencloud_ssh_password      = "passw0rd"
}