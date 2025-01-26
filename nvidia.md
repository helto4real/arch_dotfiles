# Nvidia post setup

It is super important to make the follwing changes after first reboot!!

In the file: `/etc/mkinitcpio.con`, add the following modules. You need sudo!
```
MODULES=(... nvidia nvidia_modeset nvidia_uvm nvidia_drm ...)
```
Crete the following file `/etc/modprobe.d/nvidia.conf` and add:
```
options nvidia_drm modeset=1 fbdev=1
```


