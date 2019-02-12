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
Write-Host "Installing Z-Zip from ${seven_zip_dist}"
Start-Process -FilePath msiexec -ArgumentList ("/package", "${seven_zip_dist}", "/quiet", "/qn", "/norestart") -Wait

# Download MinGW x64
$mingw_url = "${env:MINGW_RELEASE_URL}/${env:MINGW_64_TOOLCHAIN_PATH}/${env:MINGW_VERSION}/threads-${env:MINGW_64_THREADS}/${env:MINGW_64_EXCEPTIONS}/${env:MINGW_64_TARGET}-${env:MINGW_VERSION}-release-${env:MINGW_64_THREADS}-${env:MINGW_64_EXCEPTIONS}-rt_v${env:MINGW_RT_FILE_SUFFIX}-rev${env:MINGW_REVISON}${env:MINGW_URL_POSTFIX}"
Write-Host "Downloading MinGW x64 from ${mingw_url} into ${env:TMP}"
(New-Object System.Net.WebClient).DownloadFile("${mingw_url}", "${env:TMP}\mingw.7z")
# Extract MinGW x64 and install it into C:\mingw64
Write-Host "Installing MinGW x64 into C:\mingw64"
& "${env:ProgramFiles}\7-Zip\7z.exe" x "${env:TMP}\mingw.7z" -o"C:" -aoa -y

# Download MinGW x86
$mingw_url = "${env:MINGW_RELEASE_URL}/${env:MINGW_32_TOOLCHAIN_PATH}/${env:MINGW_VERSION}/threads-${env:MINGW_32_THREADS}/${env:MINGW_32_EXCEPTIONS}/${env:MINGW_32_TARGET}-${env:MINGW_VERSION}-release-${env:MINGW_32_THREADS}-${env:MINGW_32_EXCEPTIONS}-rt_v${env:MINGW_RT_FILE_SUFFIX}-rev${env:MINGW_REVISON}${env:MINGW_URL_POSTFIX}"
Write-Host "Downloading MinGW x86 from ${mingw_url} into ${env:TMP}"
(New-Object System.Net.WebClient).DownloadFile("${mingw_url}", "$env:TMP\mingw.7z")
# Extract MinGW x64 and install it into C:\mingw32
Write-Host "Installing MinGW x86 into C:\mingw32"
& "${env:ProgramFiles}\7-Zip\7z.exe" x "${env:TMP}\mingw.7z" -o"C:" -aoa -y

# Cleanup
Write-Host "Removing all files and directories from ${env:TMP}"
Remove-Item -Path "${env:TMP}\*" -Recurse -Force
