if "%VS2019_ENT_SERIAL%"=="" (
    echo "please upt the VS2019_ENT_SERIAL to the enviornment"
    exit 1
)

choco install -y virtualbox-guest-additions-guest.install

rem google changes this too often
choco install -y googlechrome --ignore-checksums

choco install -y vscode

choco install -y 7zip

choco install -y git

choco install -y svn

choco install -y putty

choco install -y winscp

choco install -y cmake.install --installargs '"ADD_CMAKE_TO_PATH=System"'

choco install -y nodejs

rem npm install --global windows-build-tools

choco install -y docker-compose

choco install -y Kubernetes-cli

choco install -y lens

choco install -y redis-desktop-manager

choco install -y python3

choco install -y rainmeter

choco install -y visualstudio2019enterprise

"C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\Common7\IDE\StorePID.exe" %VS2019_ENT_SERIAL% 09260

choco install -y visualstudio2019-workload-nativedesktop

choco install -y visualstudio2019-workload-manageddesktop

choco install -y visualstudio2019-workload-netcorebuildtools

