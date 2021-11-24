#!/bin/sh
sudo parted /dev/sdc --script mklabel gpt mkpart xfspart xfs 0% 100%
sudo mkfs.xfs /dev/sdc1
sudo partprobe /dev/sdc1
sudo mkdir /datadrive
sudo mount /dev/sdc1 /datadrive
export Datadisk=$(sudo blkid -s UUID -o value /dev/sdc1)
sudo -E bash -c 'echo UUID="$Datadisk"   /datadrive   xfs   defaults,nofail   1   2 >> /etc/fstab'