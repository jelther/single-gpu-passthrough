#!/bin/bash
set -x

LOGFILE="/var/log/libvirt/hooks-win11.log"
echo "$(date) - [HOOK] Rebinding GPU to host" >> "$LOGFILE"

# Unload VFIO module
modprobe -r vfio-pci || echo "Failed to unload VFIO" >> "$LOGFILE"

# Load NVIDIA kernel modules
modprobe nvidia_drm nvidia_modeset nvidia_uvm nvidia  || echo "Failed to load Nvidia Drivers" >> "$LOGFILE"

# Reattach GPU to host
virsh nodedev-reattach pci_0000_07_00_0 || echo "Failed to reattach GPU" >> "$LOGFILE"
virsh nodedev-reattach pci_0000_07_00_1 || echo "Failed to reattach GPU Audio" >> "$LOGFILE"

# Rebind VT consoles
echo 1 > /sys/class/vtconsole/vtcon0/bind || echo "Failed to rebind VTcon0" >> "$LOGFILE"
echo 1 > /sys/class/vtconsole/vtcon1/bind || echo "Failed to rebind VTcon1" >> "$LOGFILE"

# Rebind EFI framebuffer
if [[ -e /sys/bus/platform/drivers/efi-framebuffer/bind ]]; then
    echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/bind
fi

# Restart display manager
systemctl start display-manager.service || echo "Failed to start display-manager" >> "$LOGFILE"

echo "$(date) - [HOOK] GPU successfully restored" >> "$LOGFILE"