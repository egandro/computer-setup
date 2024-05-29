rem https://www.influxdata.com/blog/using-telegraf-on-windows/
rem https://www.influxdata.com/downloads/

rem variables can be injected via enviornment

New-Variable -Name "INFLUX_URL" -Value "http://influxdb.example.com:8086"
New-Variable -Name "INFLUX_TOKEN" -Value "foobar"
New-Variable -Name "INFLUX_ORG" -Value "org"
New-Variable -Name "INFLUX_BUCKET" -Value "bucket"

cd ~\Downloads
if (Test-Path telegraf.zip) {
   Remove-Item telegraf.zip -verbose
}

Invoke-WebRequest https://dl.influxdata.com/telegraf/releases/telegraf-1.30.3_windows_amd64.zip -OutFile telegraf.zip
Expand-Archive .\telegraf.zip 'C:\Program Files\'

ren 'C:\Program Files\telegraf-1.30.3' 'C:\Program Files\telegraf'
mkdir 'C:\Program Files\telegraf\conf'
cd 'C:\Program Files\telegraf\conf'
copy ..\telegraf.conf inputs.conf

New-Item .\outputs.conf -ItemType File

Add-Content .\outputs.conf "[[outputs.influxdb_v2]]"
Add-Content .\outputs.conf "  urls = [""$INFLUX_URL""]"
Add-Content .\outputs.conf "  token = ""$INFLUX_TOKEN"""
Add-Content .\outputs.conf "  organization = ""$INFLUX_ORG"""
Add-Content .\outputs.conf "  bucket = ""$INFLUX_BUCKET"""
Add-Content .\outputs.conf "  timeout = ""5s"""

..\telegraf.exe --config-directory 'C:\Program Files\telegraf\conf' --test

icacls outputs.conf /reset
icacls outputs.conf /inheritance:r /grant system:r

cd 'C:\Program Files\telegraf'
.\telegraf --service install --config-directory 'C:\Program Files\telegraf\conf'
net start telegraf

