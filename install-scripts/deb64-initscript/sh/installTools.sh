#!/bin/bash
read -p "Ensure that the vmware tools are ready to be mounted (Guest -> Install vmware tools). Once ready, press [Enter]"
PKG='VMwareTools-*.tar.gz'
cd
mount /dev/cdrom /mnt
cp /mnt/$PKG /root/
tar -xzvf $PKG
cd vmware-tools-distrib
perl ./vmware-install.pl -d
cd
umount /mnt
rm -rf vmware-tools-distrib
rm $PKG

