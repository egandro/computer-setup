# ESXi Thick to Thin disk

```
#https://www.alitajran.com/convert-thick-provisioned-disk-to-thin-on-vmware-esxi/
#https://znil.net/index.php/VMware:ESXi_VM_%C3%BCber_Shell_starten_oder_beenden

export VMNAME="myDebian"
export DS="datastore2"

VMID=$(vim-cmd /vmsvc/getallvms | grep  "${VMNAME}" | awk '{print $1}')

# turn off vm if running
vim-cmd vmsvc/power.off ${VMID} || true

vmkfstools -i "/vmfs/volumes/${DS}/${VMNAME}/${VMNAME}.vmdk" -d thin "/vmfs/volumes/${DS}/${VMNAME}/${VMNAME}-thin.vmdk"
mv "/vmfs/volumes/${DS}/${VMNAME}/${VMNAME}-flat.vmdk" "/vmfs/volumes/${DS}/${VMNAME}/${VMNAME}-flat.vmdk.old"
mv "/vmfs/volumes/${DS}/${VMNAME}/${VMNAME}-thin-flat.vmdk" "/vmfs/volumes/${DS}/${VMNAME}/${VMNAME}-flat.vmdk"
vim-cmd /vmsvc/unregister ${VMID}
vim-cmd solo/registervm "/vmfs/volumes/${DS}/${VMNAME}/${VMNAME}.vmx"
rm -f "/vmfs/volumes/${DS}/${VMNAME}/${VMNAME}-thin.vmdk"
rm -f "/vmfs/volumes/${DS}/${VMNAME}/${VMNAME}-flat.vmdk.old"
```
