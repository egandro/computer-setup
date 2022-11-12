# OpenWRT on ESXi

- USB Wlan
- NordVPN 

## Installation

- https://openwrt.org/docs/guide-user/virtualization/vmware
- https://kb.vmware.com/s/article/1028943


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
- USB Device <Realtek USB3.0 802.11ac 1200M Adapter (Disconnected)>

```
# Linux Machine
$ VERSION=22.03.2
$ scp openwrt-${VERSION}-x86-64-generic-ext4-combined.vmdk root@esxi:/vmfs/volumes/datastore1
```


```
# ESXi Machine
$ cd /vmfs/volumes/datastore1
$ VERSION=22.03.2
$ vmkfstools -i openwrt-${VERSION}-x86-64-generic-ext4-combined.vmdk OpenWRT.vmdk 
$ rm -f openwrt-${VERSION}-x86-64-generic-ext4-combined.vmdk
```

Copy "OpenWRT.vmdk" + "OpenWRT-flat.vmdk" to VM's folder and attach it with the UI to the machine as harddisk.


## Basic Setup

- Turn on Machine
- Login to Terminal via ESXi - set root password

```
$ vi /etc/config/network

# change interface 'lan' to

config interface 'lan'
        option device 'br-lan'
        option proto 'dhcp'
        
#####
$ reboot
# test: login wia http://openwrt...
# install ssh key http://openwrt.XXX/cgi-bin/luci/admin/system/admin/sshkeys
```

ssh to openwrt

```
opkg update
opkg install hostapd
```

## Build USB Driver

```
$ sudo apt-get install libncurses-dev zlib1g-dev gawk rsync flex libelf-dev liblzma-dev autoconf build-essential bison libssl-dev 
$ VERSION=22.03.2
$ git clone https://git.openwrt.org/openwrt/openwrt.git
$ cd openwrt
$ git pull
$ #git branch -a
$ #git tag
$ git checkout v${VERSION}
$ ./scripts/feeds update -a
$ ./scripts/feeds install -a
$ wget https://downloads.openwrt.org/releases/${VERSION}/targets/x86/64/config.buildinfo -O .config
$ curl -L https://api.github.com/repos/plntyk/openwrt/tarball \
 | tar xz --wildcards "*/package/kernel/rtl8812au-ct" --strip-components=3 -C ./package/kernel
$ make menuconfig -> save
$ make tools/install
$ make toolchain/install
$ make target/linux/compile
$ make package/kernel/linux/compile
$ make package/kernel/rtl8812au-ct/compile

```

