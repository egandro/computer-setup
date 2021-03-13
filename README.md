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
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```

basic system

```cmd
choco install -y virtualbox-guest-additions-guest.install

choco install -y chrome-remote-desktop-chrome

choco install -y vscode

choco install -y 7zip

choco install -y git

choco install -y svn

choco install -y putty

choco install -y cmake.install --installargs '"ADD_CMAKE_TO_PATH=System"'

choco install -y nodejs

rem npm install --global windows-build-tools

choco install -y python3

choco install -y visualstudio2019community

rem choco install -y visualstudio2019enterprise

choco install -y visualstudio2019-workload-nativedesktop

choco install -y visualstudio2019-workload-manageddesktop

choco install -y visualstudio2019-workload-netcoretools

```


