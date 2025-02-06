#!/bin/bash
set -x

LOGFILE="/var/log/libvirt/hooks-win11.log"
echo "$(date) - [HOOK] Preparing GPU for passthrough" >> "$LOGFILE"

# Stop display manager
systemctl stop display-manager.service || echo "Failed to stop display-manager" >> "$LOGFILE"

# Unbind VT consoles
echo 0 > /sys/class/vtconsole/vtcon0/bind || echo "Failed to unbind VTcon0" >> "$LOGFILE"
echo 0 > /sys/class/vtconsole/vtcon1/bind || echo "Failed to unbind VTcon1" >> "$LOGFILE"

# Unbind EFI framebuffer
if [[ -e /sys/bus/platform/drivers/efi-framebuffer/unbind ]]; then
    echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind
fi

# Wait to prevent race condition
sleep 2

# Unload NVIDIA kernel modules
modprobe -r nvidia_drm nvidia_modeset nvidia_uvm nvidia  || echo "Failed to unload Nvidia Drivers" >> "$LOGFILE"

# Unbind GPU
virsh nodedev-detach pci_0000_07_00_0 || echo "Failed to detach GPU" >> "$LOGFILE"
virsh nodedev-detach pci_0000_07_00_1 || echo "Failed to detach GPU Audio" >> "$LOGFILE"

# Load VFIO module
modprobe vfio-pci || echo "Failed to load VFIO" >> "$LOGFILE"

echo "$(date) - [HOOK] GPU passed successfully to VM" >> "$LOGFILE"