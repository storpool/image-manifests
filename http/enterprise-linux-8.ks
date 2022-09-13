# AlmaLinux 8 kickstart file for Generic Cloud (OpenStack) image

url --url https://repo.almalinux.org/almalinux/8/BaseOS/x86_64/kickstart/
repo --name=BaseOS --baseurl=https://repo.almalinux.org/almalinux/8/BaseOS/x86_64/os/
repo --name=AppStream --baseurl=https://repo.almalinux.org/almalinux/8/AppStream/x86_64/os/

text
skipx
eula --agreed
firstboot --disabled

lang en_US.UTF-8
keyboard us
timezone Europe/Sofia --isUtc

network --bootproto=dhcp --device=eth0 --ipv6=auto --activate
firewall --disabled
services --enabled="chronyd,rsyslog,sshd"
selinux --disabled

zerombr
bootloader --location=mbr --append=" rhgb crashkernel=auto"
clearpart --all --initlabel
partition biosboot --asprimary --fstype="biosboot" --size=1
partition /boot/efi --asprimary --fstype="efi" --label ESP --size=200
partition / --asprimary --fstype="xfs" --label ROOTFS --size=4096 --grow


rootpw $1$7dmhv3$4e7LCZJCqDuPa1fHOzTzX. --iscrypted

reboot --eject

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
