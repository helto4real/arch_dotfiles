
# Setup a virtual QEMU machine to test the installaton

0. Create a virtual drive `qemu-img create -f qcow2 ~/qemu/arctest.cov 10G`
1. Copy the uefi boot image to the qeumu folder `cp /usr/share/OVMF/x64/OVMF_CODE.4m.fd ~/qemu/`
3. Make it writable `sudo chmod +w ~/qemu/OVMF_CODE.4m.fd`
4. Install archlinux with `qemu-system-x86_64 -cdrom ~/Downloads/archlinux-2025.01.01-x86_64.iso -boot order=d -m 4096 -accel kvm -drive if=pflash,format=raw,file=/home/thhel/qemu/OVMF_CODE.4m.fd -drive file=~/qemu/arctest.cov,format=qcow2`
5. Run the image without the cdrom option `qemu-system-x86_64 -boot order=d -m 4096 -accel kvm -drive if=pflash,format=raw,file=/home/thhel/qemu/OVMF_CODE.4m.fd -drive file=~/qemu/arctest.cov,format=qcow2`
