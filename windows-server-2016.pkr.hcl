source "qemu" "windows-2016" {
  iso_url            = "file:///opt/image-base-cache/Windows_Server_2016_Datacenter_EVAL_en-us_14393_refresh.ISO"
  iso_checksum       = "sha256:1ce702a578a3cb1ac3d14873980838590f06d5b7101c5daaccbac9d73f1fb50f"
  shutdown_command   = "shutdown /s /t 30 /f"
  shutdown_timeout   = "15m"
  boot_wait          = "4s"
  boot_command       = [ "<enter><wait4><enter><wait4><enter>" ]
  accelerator        = "kvm"
  cd_files           = [ "./win/2016-server/Autounattend.xml", "./scripts/win-common/fixnetwork.ps1", "./scripts/win-common/ConfigureRemotingForAnsible.ps1", "./scripts/win-common/cloudbase-init.conf", "./scripts/win-common/cloudbase-init-unattend.conf" ]
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
  source "qemu.windows-2016" {
    vm_name           = "windows-2016.raw"
    output_directory  = "builds/cloud/windows-2016/${formatdate("YYYY-MM-DD-hh", timestamp())}"
  }

  name = "localdisk"

  provisioner "powershell" {
    script = "./scripts/win-common/cloudbase.ps1"
    elevated_user = "Administrator"
    elevated_password = "passw0rd"
  }
}

