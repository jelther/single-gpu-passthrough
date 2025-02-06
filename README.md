# Single GPU Passthrough
Personal scripts to enable a Single GPU Passthrough on Linux VM

# Previous steps

- Need to install libvirt, create a virtual machine and pass devices to the VM.

# How to

> You can find more information about how libvirt manages hooks here https://libvirt.org/hooks.html


All needed files are under hooks folder on this repository.

Copy them to `/etc/libvirt/hooks` and you're good to go! 

My setup is a Nvidia GPU + AMD CPU with a virtual machine named `win11`, adjust accordingly.