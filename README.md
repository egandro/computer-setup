# computer-setup


## debian


### system 
usage

```bash
$ wget https://raw.githubusercontent.com/egandro/computer-setup/master/debian-install.sh && chmod 755 sudo ./debian-install.sh && ./debian-install.sh
```



### docker only(old)
usage

```bash
$ wget https://raw.githubusercontent.com/egandro/computer-setup/master/debian-docker.sh && chmod 755 ./debian-docker.sh && sudo ./debian-docker.sh
```

### raspberry router
install raspbian
put this files in the BOOT partition (ssh is an empty file - no extensions)
  - ssh
  - wpa_supplicant.conf

wpa_supplicant.conf:
```
country=EU
ctrl_interface=DIR=/var/run/wpa_supplicantGROUP=netdev
update_config=1
network={
    ssid="wifi_id"
    psk="wifi_password"
    key_mgmt=WPA-PSK
    priority=1
}
```


```bash
$ export CFG_HOSTNAME=router
$ export CFG_USER=hacker
$ export CFG_PASSWORD=secret
$ export CFG_WORLD_DEV=eth0
$ export CFG_IP_PREFIX=192.168.1
$ export CFG_IP_ROUTER_POSTFIX=1
$ export CFG_AP_SID=WLANrouter
$ export CFG_AP_PASS=testtest
$ wget https://raw.githubusercontent.com/egandro/computer-setup/master/pi-router.sh && chmod 755 ./pi-router.sh && sudo -E ./pi-router.sh
$ reboot
```



### windows 

Chocolaty setup
```powershell
# elevated powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```

basic system

```cmd
rem elevated cmd.exe
curl -o windows-install.cmd https://raw.githubusercontent.com/egandro/computer-setup/master/windows-install.cmd 
set VS2019_ENT_SERIAL=123123123123123
windows-install.cmd
```


