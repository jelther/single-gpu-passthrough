# Single GPU Passthrough
Personal scripts to enable a Single GPU Passthrough on Linux VM

# Previous steps

- Need to install libvirt, create a virtual machine and pass devices to the VM.

# How to

> You can find more information about how libvirt manages hooks here https://libvirt.org/hooks.html


All needed files are under hooks folder on this repository.

0. Remove hooks from previous configuration for VM `win11` if they exist

```bash
sudo rm -rf /etc/libvirt/hooks/qemu.d/win11
```

1. Copy files to `/etc/libvirt/hooks/` folder 

```bash
sudo cp hooks/qemu /etc/libvirt/hooks/
```

2. Change permissions to the files using

```bash
sudo chmod +x /etc/libvirt/hooks/qemu
sudo chmod +x /etc/libvirt/hooks/qemu.d/win11/prepare/begin.sh
sudo chmod +x /etc/libvirt/hooks/qemu.d/win11/release/end.sh
```

3. Test the scripts by running the following command

```bash
sudo /etc/libvirt/hooks/qemu win11 prepare begin
sudo /etc/libvirt/hooks/qemu win11 release end
```


# Notes

My setup is a Nvidia GPU + AMD CPU with a virtual machine named `win11`, adjust accordingly.


# Acknowledgments

- https://github.com/joeknock90/Single-GPU-Passthrough