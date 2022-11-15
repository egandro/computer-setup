# Vagrant ESXi driver

```env
ESXI_HOSTNAME=esxi.myserver
ESXI_USERNAME=root
ESXI_UPASSWORD=key:~/.ssh/your_ssh_key
ESXI_DISK_STORE=datastore2
GUEST_NAME=debianbox
GUEST_USERNAME=vagrant
BOX=generic/debian11
PROVISION_SCRIPT=./script.sh
```

```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

# install this https://developer.vmware.com/web/tool/4.4.0/ovf (or newer)

# https://github.com/josenk/vagrant-vmware-esxi
# https://www.nickhammond.com/configuring-vagrant-virtual-machines-with-env/

# $ sudo apt-get install vagrant rsync
# $ vagrant plugin install vagrant-vmware-esxi
# $ vagrant plugin install vagrant-env
# $ vagrant plugin list
# $ vagrant version

Vagrant.configure("2") do |config|
  config.env.enable
  config.vm.box = ENV['BOX']

  config.vm.synced_folder ".", "/vagrant", disabled: true
  #config.vm.synced_folder('.', '/vagrant', type: 'rsync')
  #config.vm.synced_folder('.', '/vagrant', type: 'nfs', disabled: true)

  config.vm.provider :vmware_esxi do |esxi|

    esxi.esxi_hostname = ENV['ESXI_HOSTNAME']
    esxi.esxi_username = ENV['ESXI_USERNAME']

    #  IMPORTANT!  Set ESXi password.
    #    1) 'prompt:'
    #    2) 'file:'  or  'file:my_secret_file'
    #    3) 'env:'  or 'env:my_secret_env_var'
    #    4) 'key:'  or  key:~/.ssh/some_ssh_private_key'
    #    5) or esxi.esxi_password = 'my_esxi_password'
    esxi.esxi_password = ENV['ESXI_UPASSWORD']

    esxi.esxi_hostport = 22

    #  HIGHLY RECOMMENDED!  ESXi Virtual Network
    #    You should specify an ESXi Virtual Network!  If it's not specified, the
    #    default is to use the first found.  You can specify up to 10 virtual
    #    networks using an array format.
    #esxi.esxi_virtual_network = ['VM Network','VM Network2','VM Network3','VM Network4']
    esxi.esxi_virtual_network =  ['VM Network']

    #  OPTIONAL.  Specify a Disk Store
    #esxi.esxi_disk_store = 'DS_001'
    esxi.esxi_disk_store = ENV['ESXI_DISK_STORE']

    #  OPTIONAL.  Resource Pool
    #     Vagrant will NOT create a Resource pool it for you.
    #esxi.esxi_resource_pool = '/Vagrant'

    #  Optional. Specify a VM to clone instead of uploading a box.
    #    Vagrant can use any stopped VM as the source 'box'.   The VM must be
    #    registered, stopped and must have the vagrant insecure ssh key installed.
    #    If the VM is stored in a resource pool, it must be specified.
    #    See wiki: https://github.com/josenk/vagrant-vmware-esxi/wiki/How-to-clone_from_vm
    #esxi.clone_from_vm = 'resource_pool/source_vm'

    #  OPTIONAL.  Guest VM name to use.
    #    The Default will be automatically generated.
    esxi.guest_name = ENV['GUEST_NAME']

    #  OPTIONAL.  When automatically naming VMs, use this prefix.
    #esxi.guest_name_prefix = 'V-'

    #  OPTIONAL.  Set the guest username login.  The default is 'vagrant'.
    esxi.guest_username = ENV['GUEST_USERNAME']

    #  OPTIONAL.  Memory size override
    esxi.guest_memsize = '2048'

    #  OPTIONAL.  Virtual CPUs override
    esxi.guest_numvcpus = '2'

    #  OPTIONAL & RISKY.  Specify up to 10 MAC addresses
    #    The default is ovftool to automatically generate a MAC address.
    #    You can specify an array of MAC addresses using upper or lower case,
    #    separated by colons ':'.
    #esxi.guest_mac_address = ['00:50:56:aa:bb:cc', '00:50:56:01:01:01','00:50:56:02:02:02','00:50:56:BE:AF:01' ]

    #   OPTIONAL & RISKY.  Specify a guest_nic_type
    #     The validated list of guest_nic_types are 'e1000', 'e1000e', 'vmxnet',
    #     'vmxnet2', 'vmxnet3', 'Vlance', and 'Flexible'.
    esxi.guest_nic_type = 'e1000'

    #  OPTIONAL. Specify a disk type.
    #    If unspecified, it will be set to 'thin'.  Otherwise, you can set to
    #    'thin', 'thick', or 'eagerzeroedthick'
    #esxi.guest_disk_type = 'thick'
    esxi.guest_disk_type = 'thin'

    #  OPTIONAL. Boot disk size.
    #    If unspecified, the boot disk size will be the same as the original
    #    box.  You can specify a larger boot disk size in GB.  The extra disk space
    #    will NOT automatically be available to your OS.  You will need to
    #    create or modify partitions, LVM and/or filesystems.
    #esxi.guest_boot_disk_size = 50

    #  OPTIONAL.  Create additional storage for guests.
    #    You can specify an array of up to 13 virtual disk sizes (in GB) that you
    #    would like the provider to create once the guest has been created.  You
    #    can optionally specify the size and datastore using a hash.
    #esxi.guest_storage = [ 10, 20, { size: 30, datastore: 'datastore1' } ]

    #  OPTIONAL. specify snapshot options.
    #esxi.guest_snapshot_includememory = 'true'
    #esxi.guest_snapshot_quiesced = 'true'

    #  RISKY. guest_guestos
    #    https://github.com/josenk/vagrant-vmware-esxi/wiki/VMware-ESXi-6.5-guestOS-types
    esxi.guest_guestos = ENV['BOX']

    #  OPTIONAL. guest_virtualhw_version
    #    ESXi 6.7 supports these versions. 4,7,8,9,10,11,12,13 & 14.
    #esxi.guest_virtualhw_version = '9'
    esxi.guest_virtualhw_version = '18'

    #  OPTIONAL. Guest Autostart
    #    Guest VM will autostart when esxi host is booted. 'true' or 'false'(default)
    #esxi.guest_autostart = 'false'

    #  RISKY. guest_custom_vmx_settings
    #esxi.guest_custom_vmx_settings = [['vhv.enable','TRUE'], ['floppy0.present','TRUE']]

    #  OPTIONAL. local_lax
    #esxi.local_lax = 'true'

    #  OPTIONAL. Guest IP Caching
    #esxi.local_use_ip_cache = 'True'

    #  DANGEROUS!  Allow Overwrite
    #    If unspecified, the default is to produce an error if overwriting
    #    VMs and packages.
    esxi.local_allow_overwrite = 'True'

    #  Advanced Users.
    #    If set to 'True', all WARNINGS will produce a FAILURE and Vagrant will stop.
    #esxi.local_failonwarning = 'True'

    #  Plugin debug output.
    #    Please send any bug reports with this debug output...
    #esxi.debug = 'true'

  end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL

  config.vm.provision "shell", path: ENV['PROVISION_SCRIPT']
end

```
