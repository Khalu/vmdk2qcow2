# vmdk2qcow2
convert VMWare (vmdk) and VirtualBox (.ova) VM files to QEMU-KVM VM disk files (.qcow2)

Download:
```
    wget  https://raw.githubusercontent.com/Khalu/vmdk2qcow2/master/vmdk2qcow2.sh
```
Useage: 
```
./vmdk2qcow2.sh /filepath/to/ova/file/or/VMWare/directory
```
Created for ease of creating qcow2 disks for qemu-kvm hypervisor from VirtualBox and VMWare Player disk files.

Summary:
Converts VMDK files using qemu-img to qcow2 format and places in the current directory. If an OVA file is specified it the script will extract the files to the /tmp/ directory, convert the disk image into the current directory, and delete the /temp/. 
