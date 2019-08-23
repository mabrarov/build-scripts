#
# Copyright (c) 2019 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

# Enable all versions of TLS
[System.Net.ServicePointManager]::SecurityProtocol = @("Tls12","Tls11","Tls","Ssl3")

# Download Visual Studio 2015 Community edition
$msvs_url = "${env:MSVS_URL}"
$msvs_dist = "${env:TMP}\${env:MSVS_DIST_NAME}"
Write-Host "Downloading Visual Studio 2015 Community edition from ${msvs_url} into ${msvs_dist}"
(New-Object System.Net.WebClient).DownloadFile("${msvs_url}", "${msvs_dist}")

# Install Visual C++ part of Visual Studio 2015 Community edition
Write-Host "Installing Visual C++ part of Visual Studio 2015 Community edition with support of Desktop applications and MFC"
$p = Start-Process -FilePath "${msvs_dist}" -ArgumentList `
  ("/quiet", `
   "/norestart", `
   "/SuppressRefreshPrompt", `
   "/NoCacheOnlyMode", `
   "/AdminFile", `
   "${PSScriptRoot}\deploy.xml") `
  -Wait -PassThru
if (${p}.ExitCode -ne 0) {
  throw "Failed to install Visual Studio 2015 Community edition"
}
Write-Host "Visual C++ part of Visual Studio 2015 (${env:MSVS_VERSION}) installed"

# Download and install Visual Studio Locator
$vswhere_url = "${env:VSWHERE_URL}/${env:VSWHERE_VERSION}/${env:VSWHERE_DIST_NAME}"
$vswhere_dist = "${env:SystemRoot}\${env:VSWHERE_DIST_NAME}"
Write-Host "Downloading Visual Studio Locator from ${vswhere_url} into ${vswhere_dist}"
(New-Object System.Net.WebClient).DownloadFile("${vswhere_url}", "${vswhere_dist}")
Write-Host "Visual Studio Locator ${env:VSWHERE_VERSION} installed"

# Cleanup
Write-Host "Removing all files and directories from ${env:TMP}"
Remove-Item -Path "${env:TMP}\*" -Recurse -Force -ErrorAction SilentlyContinue
