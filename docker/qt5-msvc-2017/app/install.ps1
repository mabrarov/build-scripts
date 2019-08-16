#
# Copyright (c) 2019 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

# Enable all versions of TLS
[System.Net.ServicePointManager]::SecurityProtocol = @("Tls12","Tls11","Tls","Ssl3")

# Download and install jom
$jom_url_version_suffix = "${env:JOM_VERSION}" -replace "\.", "_"
$jom_dist_filename = "jom_${jom_url_version_suffix}.zip"
$jom_url = "${env:JOM_URL}/${jom_dist_filename}"
$jom_dist = "${env:TMP}\${jom_dist_filename}"
Write-Host "Downloading jom from ${jom_url} into ${jom_dist}"
(New-Object System.Net.WebClient).DownloadFile("${jom_url}", "${jom_dist}")
Write-Host "Installing jom into ${env:JOM_HOME}"
& "${env:SEVEN_ZIP_HOME}\7z.exe" x "${jom_dist}" -o"${env:JOM_HOME}" -aoa -y -bd | out-null
Write-Host "Jom ${env:JOM_VERSION} installed"

# Cleanup
Write-Host "Removing all files and directories from ${env:TMP}"
Remove-Item -Path "${env:TMP}\*" -Recurse -Force
