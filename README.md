# vmdk2qcow2
Bash script to convert VMWare (vmdk) and VirtualBox (.ova) VM files to QEMU-KVM VM disk files (.qcow2)

Download:
```
    wget  https://raw.githubusercontent.com/Khalu/vmdk2qcow2/master/vmdk2qcow2.sh
```
or 
```
    git clone https://github.com/Khalu/vmdk2qcow2
```

Useage: 
```
chmod +x ./vmdk2qcow2.sh
./vmdk2qcow2.sh /filepath/to/ova/file/or/VMWare/directory /filepath/to/output/directory
```
or 
```
./vmdk2qcow2.sh
```
And wait to be prompted.

Created for ease of creating qcow2 disks for qemu-kvm hypervisor from VirtualBox and VMWare Player disk files.

Summary:
Converts VMDK files using qemu-img to qcow2 format and places in the current directory. If an OVA file is specified it the script will extract the files to the /tmp/ directory, convert the disk image into the current directory, and delete the /temp/. 

TODO:

Add named arugments

Import to qemu automatically 

Other hypervisor support(?)



[Link to Blog Post](https://n00bsecurityblog.wordpress.com/2019/11/10/how-to-convert-vmware-and-virtualbox-vm-files-to-qemu-kvm/)
