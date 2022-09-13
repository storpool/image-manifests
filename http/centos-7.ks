# Install the OS
install

# Keyboard layout
keyboard us

# Root password
rootpw $1$7dmhv3$4e7LCZJCqDuPa1fHOzTzX. --iscrypted

# System Language
lang en_US.UTF-8

# Reboot after installation
reboot

# System timezone
timezone Europe/Sofia --isUtc

# Use text mode install
text

# Disk Partitioning
zerombr
bootloader --location=mbr --append=" rhgb crashkernel=auto"
clearpart --all --initlabel
partition biosboot --asprimary --fstype="biosboot" --size=1
partition /boot/efi --asprimary --fstype="efi" --label ESP --size=200
partition / --asprimary --fstype="xfs" --label ROOTFS --size=4096 --grow

# System authorization information
auth  --useshadow  --passalgo=sha512

# Network information
network  --bootproto=dhcp --device=eth0 --ipv6=auto --activate
firewall --disabled

# SELinux disables
selinux --disabled

# Do not configure the X Window System
skipx

# Use network installation
url --url=http://mirrors.neterra.net/centos/7.9.2009/os/x86_64/

# Agree to the EULA
eula --agreed

# Enable first boot agent
firstboot --disable

# Create storpool user used by Packer
user --name=storpool --groups=wheel --password=$6$nS5Wz8uuh7nWVZii$S7fI00iocymuAu2373SOtFKLOa0Af7qtJxvl6Dw5dpdVjbK9W988rr4tXgZWfRvJYgTn5MGjXj1r7O.6FkL7n0 --iscrypted --shell=/bin/bash

%packages
@^minimal
@base
acpid
libcgroup
libcgroup-tools
ncurses-term
nvme-cli
yum-plugin-verify
%end

%addon com_redhat_kdump --enable --reserve-mb='auto'
%end

%post
echo "storpool ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
%end

