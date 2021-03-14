if "%VS2019_ENT_SERIAL%"=="" (
    echo "please upt the VS2019_ENT_SERIAL to the enviornment"
    exit 1
)

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

choco install -y visualstudio2019enterprise

choco install -y visualstudio2019-workload-nativedesktop

choco install -y visualstudio2019-workload-manageddesktop

choco install -y visualstudio2019-workload-netcorebuildtools

"C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\Common7\IDE\StorePID.exe" %VS2019_ENT_SERIAL% 09260
