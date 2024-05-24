# computer-setup

## Debian

### System
usage

```bash
$ wget https://raw.githubusercontent.com/egandro/computer-setup/master/debian-install.sh && chmod 755 ./debian-install.sh && sudo ./debian-install.sh
```

### Dev Tools
usage

```bash
$ wget https://raw.githubusercontent.com/egandro/computer-setup/master/debian-dev-tools.sh && chmod 755 ./debian-dev-tools.sh && sudo ./debian-dev-tools.sh
```

### Docker only(old)
usage

```bash
$ wget https://raw.githubusercontent.com/egandro/computer-setup/master/debian-docker.sh && chmod 755 ./debian-docker.sh && sudo ./debian-docker.sh
```

### Windows

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

docker-machine

  - Unoffcial Docker2Toolbox <https://github.com/kaosagnt/toolbox2docker/releases>

```cmd
docker-machine create --virtualbox-disk-size "100000" --virtualbox-memory "8192" --virtualbox-cpu-count "4" default
```

mstsc to handle 4k screens

  - Tutorial how to make a mstsc copy and add HiDPI flag <https://poweruser.blog/remote-desktop-client-on-hidpi-retina-displays-work-around-pixel-scaling-issues-1529f142ca93>

### Android Termux

```bash
curl -o android-termux.sh https://raw.githubusercontent.com/egandro/computer-setup/master/android-termux.sh && chmod 755 android-termux.sh && ./android-termux.sh
```
