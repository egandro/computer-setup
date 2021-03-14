# computer-setup


## debian


### system 
usage

```bash
$ wget https://raw.githubusercontent.com/egandro/computer-setup/master/debian-install.sh && chmod 755 ./debian-install.sh && ./debian-install.sh
```



### docker only
usage

```bash
$ wget https://raw.githubusercontent.com/egandro/computer-setup/master/debian-docker.sh && chmod 755 ./debian-docker.sh && sudo ./debian-docker.sh
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


