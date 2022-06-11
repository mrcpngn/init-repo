1. Mount the iso
mount -o loop AlmaLinux-8.5-x86_64-minimal.iso raw-iso

2. Copy the contents of the iso file
shopt -s dotglob
mkdir /tmp/rhel7
cp -avRf raw-iso/* temp-iso

3. Get the label
blkid AlmaLinux-8.5-x86_64-minimal.iso 
AlmaLinux-8-5-x86_64-dvd

4. Modify the isolinux/isolinux.cfg

label kickstart
  menu label ^Kickstart Installation of AlmaLinux 8.5
  menu default
  kernel vmlinuz
  append initrd=initrd.img inst.stage2=hd:LABEL=AlmaLinux-8-5-x86_64-dvd inst.ks=cdrom:/ks.cfg


5. Modify the EFI/BOOT/grub.cfg

### BEGIN /etc/grub.d/10_linux ###
menuentry 'Install AlmaLinux 8.5' --class fedora --class gnu-linux --class gnu --class os {
	linuxefi /images/pxeboot/vmlinuz inst.stage2=hd:LABEL=AlmaLinux-8-5-x86_64-dvd inst.ks=cdrom:/ks.cfg quiet
	initrdefi /images/pxeboot/initrd.img
}

6. Execute the commands below:
sudo mkisofs -o ~/custom-iso/AlmaLinux8-test.iso -b isolinux/isolinux.bin -J -R -l -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e images/efiboot.img -no-emul-boot -graft-points -V "AlmaLinux-8-5-x86_64-dvd" .

sudo isohybrid --uefi ~/custom-iso/AlmaLinux8-test.iso

sudo implantisomd5 ~/custom-iso/AlmaLinux8-test.iso

7. Test the ISO
