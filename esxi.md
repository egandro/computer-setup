# ESXi commands

## ESXi Thick to Thin disk

```
#https://www.alitajran.com/convert-thick-provisioned-disk-to-thin-on-vmware-esxi/
#https://znil.net/index.php/VMware:ESXi_VM_%C3%BCber_Shell_starten_oder_beenden

export VMNAME="myDebian"
export DS="datastore2"

if [ ! -f "/vmfs/volumes/${DS}/${VMNAME}/${VMNAME}.vmdk" ]; then
    echo "/vmfs/volumes/${DS}/${VMNAME}/${VMNAME}.vmdk" does not exist.
    exit 1
fi

VMID=$(vim-cmd /vmsvc/getallvms | grep  "${VMNAME}" | awk '{print $1}')

# turn off vm if running
vim-cmd vmsvc/power.off ${VMID} || true

# check the disk
vmkfstools --fix check "/vmfs/volumes/${DS}/${VMNAME}/${VMNAME}.vmdk" || exit 1

vmkfstools -i "/vmfs/volumes/${DS}/${VMNAME}/${VMNAME}.vmdk" -d thin "/vmfs/volumes/${DS}/${VMNAME}/${VMNAME}-thin.vmdk"
mv "/vmfs/volumes/${DS}/${VMNAME}/${VMNAME}-flat.vmdk" "/vmfs/volumes/${DS}/${VMNAME}/${VMNAME}-flat.vmdk.old"
mv "/vmfs/volumes/${DS}/${VMNAME}/${VMNAME}-thin-flat.vmdk" "/vmfs/volumes/${DS}/${VMNAME}/${VMNAME}-flat.vmdk"
vim-cmd /vmsvc/unregister ${VMID}
vim-cmd solo/registervm "/vmfs/volumes/${DS}/${VMNAME}/${VMNAME}.vmx"
rm -f "/vmfs/volumes/${DS}/${VMNAME}/${VMNAME}-thin.vmdk"
rm -f "/vmfs/volumes/${DS}/${VMNAME}/${VMNAME}-flat.vmdk.old"
```

## ESXi snapshot

```
#https://www.xmsoft.de/2019/03/07/create-snapshot-including-memory-on-esxi-command-line/

export VMNAME="myDebian"

if [ ! -f "/vmfs/volumes/${DS}/${VMNAME}/${VMNAME}.vmdk" ]; then
    echo "/vmfs/volumes/${DS}/${VMNAME}/${VMNAME}.vmdk" does not exist.
    exit 1
fi

VMID=$(vim-cmd /vmsvc/getallvms | grep  "${VMNAME}" | awk '{print $1}')

# vim-cmd vmsvc/snapshot.create VMID snapshotName description includeMemory quiesced
vim-cmd vmsvc/snapshot.create ${VMID} "SnapshotName" "Snapshot Description" true true 

# vim-cmd vmsvc/snapshot.removeall  ${VMID}


```
