# ESXi Thick to Thin disk

```
#https://www.alitajran.com/convert-thick-provisioned-disk-to-thin-on-vmware-esxi/
VMNAME=myDebian
DS=datastore2
vmkfstools -i /vmfs/volumes/${DS}/${VMNAME}/${VMNAME}.vmdk -d thin /vmfs/volumes/${DS}/${VMNAME}/${VMNAME}-thin.vmdk
mv /vmfs/volumes/${DS}/${VMNAME}/${VMNAME}-flat.vmdk /vmfs/volumes/${DS}/${VMNAME}/${VMNAME}-flat.vmdk.old
mv /vmfs/volumes/${DS}/${VMNAME}/${VMNAME}-thin-flat.vmdk /vmfs/volumes/${DS}/${VMNAME}/${VMNAME}-flat.vmdk
VMID=$(vim-cmd /vmsvc/getallvms | grep  ${VMNAME} | awk '{print $1}')
vim-cmd /vmsvc/unregister ${VMID}
vim-cmd solo/registervm /vmfs/volumes/${DS}/${VMNAME}/${VMNAME}.vmx
rm -f /vmfs/volumes/${DS}/${VMNAME}/${VMNAME}-thin.vmdk
rm -f /vmfs/volumes/${DS}/${VMNAME}/${VMNAME}-flat.vmdk.old
```
