# OpenWRT on ESXi

- USB Wlan
- NordVPN 

## Installation

- https://openwrt.org/docs/guide-user/virtualization/vmware


```
$ sudo apt-get install -y qemu-utils
$ VERSION=22.03.2
$ wget -q https://archive.openwrt.org/releases/${VERSION}/targets/x86/64/openwrt-${VERSION}-x86-64-generic-ext4-combined.img.gz
$ gzip -d openwrt-${VERSION}-x86-64-generic-ext4-combined.img.gz
$ qemu-img convert -f raw -O vmdk openwrt-${VERSION}-x86-64-generic-ext4-combined.img openwrt-${VERSION}-x86-64-generic-ext4-combined.vmdk
$ rm -f openwrt-${VERSION}-x86-64-generic-ext4-combined.img
```

## ESXi Machine

- ESXi 7/8...
- Linux
- Ubuntu Linux (64-bit)
- 2GB
- LSI Logic
- Delete Disk
- USB3.1
- Network Adapter Type E1000
- Delete DVD
