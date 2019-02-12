#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

# Enable all versions of TLS
[System.Net.ServicePointManager]::SecurityProtocol = @("Tls12","Tls11","Tls","Ssl3")

# Download Z-Zip
$app_dir = "C:\app"
$seven_zip_dist_name = "7z${env:SEVEN_ZIP_VERSION}-x64.msi"
$seven_zip_dist = "${app_dir}\${seven_zip_dist_name}"
if (-not (Test-Path -Path "${seven_zip_dist}")) {
  $seven_zip_url = "${env:SEVEN_ZIP_DOWNLOAD_URL}/${seven_zip_dist_name}"
  Write-Host "Downloading Z-Zip from ${seven_zip_url} into ${seven_zip_dist_name}"
  (New-Object System.Net.WebClient).DownloadFile("${seven_zip_url}", "${seven_zip_dist_name}")
}

# Install Z-Zip
Write-Host "Installing Z-Zip from ${seven_zip_dist} into C:\Program Files\7-Zip"
Start-Process -FilePath msiexec -ArgumentList ("/package", "${seven_zip_dist}", "/quiet", "/qn", "/norestart") -Wait

# Download MSYS2
$msys_url = "${env:MSYS2_URL}%2F${env:MSYS2_VERSION}%2F${env:MSYS2_TARGET}%2Fmsys2-base-devel-${env:MSYS2_TARGET}-${env:MSYS2_VERSION}.7z"
Write-Host "Downloading MSYS2 x64 from ${msys_url} into ${env:TMP}"
(New-Object System.Net.WebClient).DownloadFile("${msys_url}", "${env:TMP}\msys2.7z")

# Extract MSYS2 x64 and install it into C:\mingw64
Write-Host "Installing MSYS2 x64 into C:\msys64"
& "${env:ProgramFiles}\7-Zip\7z.exe" x "${env:TMP}\msys2.7z" -o"C:" -aoa -y

# Cleanup
Write-Host "Removing all files and directories from ${env:TMP}"
Remove-Item -Path "${env:TMP}\*" -Recurse -Force
