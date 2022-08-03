# Description
Linaud is an audit tool for Linux. 

# Compatibility
- Debian 
- Ubuntu 
- Kali Linux 
- Arch 

# Features 
## CPU 
### PAE 
Enable PAE/NX: Determines whether the PAE and NX capabilities of the host CPU will be exposed to the virtual machine. PAE stands for Physical Address Extension. Normally, if enabled and supported by the OS, then even a 32-bit x86 CPU can access more than 4 GB of RAM. For Intel CPUs, the option is grayed out.
### NX 
The NX bit (no-execute) is a technology used in CPUs to segregate areas of memory for use by either storage of processor instructions (code) or for storage of data, a feature normally only found in Harvard architecture processors.
## GRUB 
### /etc/grub.d 

### /boot.grub

### GRUB password 
It is recommended to set a password for GRUB. 
`grub-md5-crypt`

### IOMMU 


