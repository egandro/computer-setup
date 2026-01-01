# computer-setup

## Debian

### bootstrap

**usage**

```bash
$ wget -qO- https://raw.githubusercontent.com/egandro/computer-setup/main/bootstrap.sh | bash
```

### Windows

**Chocolaty setup**

```powershell
# elevated powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```

**basic system**

```cmd
rem elevated cmd.exe
rem curl -o windows-install.cmd https://raw.githubusercontent.com/egandro/computer-setup/main/windows-install.cmd
set VS2019_ENT_SERIAL=123123123123123
windows-install.cmd
```

### Android Termux

```bash
curl -o android-termux.sh https://raw.githubusercontent.com/egandro/computer-setup/main/android-termux.sh && chmod 755 android-termux.sh && ./android-termux.sh
```
