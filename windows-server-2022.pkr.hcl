source "qemu" "windows-server-2022" {
  iso_url            = "file:///opt/image-base-cache/SERVER_EVAL_x64FRE_en-us.iso"
  iso_checksum       = "sha256:3e4fa6d8507b554856fc9ca6079cc402df11a8b79344871669f0251535255325"
  shutdown_command   = "shutdown /s /t 30 /f"
  shutdown_timeout   = "15m"
  boot_wait          = "4s"
  boot_command       = [ "<enter><wait4><enter><wait4><enter>" ]
  accelerator        = "kvm"
  cd_files           = [ "./asd.xml" ]
  cpus               = var.cpus
  disk_interface     = "virtio-scsi"
  disk_size          = 15360
  disk_cache         = "unsafe"
  disk_discard       = "unmap"
  disk_detect_zeroes = "unmap"
  efi_boot           = "true"
  efi_firmware_code  = "/usr/share/OVMF/OVMF_CODE.secboot.fd"
  efi_firmware_vars  = "/usr/share/OVMF/OVMF_VARS.fd"
  format             = "raw"
  headless           = var.headless
  machine_type       = "q35"
  memory             = var.memory
  net_device         = "virtio-net"
  qemu_binary        = var.qemu_binary
  qemuargs           = [ [ "-cdrom", "/opt/image-base-cache/virtio-win.iso" ] ]
  communicator       = "winrm"
  winrm_username     = "storpool"
  winrm_password     = "passw0rd"
  winrm_use_ssl      = "true"
  winrm_insecure     = "true"
  winrm_timeout      = "1h"
}

build {
  source "qemu.windows-server-2022" {
    vm_name           = "windows-server-2022.raw"
    output_directory  = "builds/cloud/windows-server-2022/${formatdate("YYYY-MM-DD-hh", timestamp())}"
  }

  name = "localdisk"

  #provisioner "powershell" {
  #  script = "./scripts/win-common/cloudbase.ps1"
  #  elevated_user = "Administrator"
  #  elevated_password = "passw0rd"
  #}
}

