#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

# Enable all versions of TLS
[System.Net.ServicePointManager]::SecurityProtocol = @("Tls12","Tls11","Tls","Ssl3")

# Download Visual Studio 2017 Community edition
$msvs_url = "${env:MSVS_URL}/${env:MSVS_VERSION}/release/${env:MSVS_DIST_NAME}"
$msvs_dist = "${env:TMP}\${env:MSVS_DIST_NAME}"
Write-Host "Downloading Visual Studio 2017 Community edition from ${msvs_url} into ${msvs_dist}"
(New-Object System.Net.WebClient).DownloadFile("${msvs_url}", "${msvs_dist}")

# Install Visual C++ part of Visual Studio 2017 Community edition
Write-Host "Installing Visual C++ part of Visual Studio 2017 Community edition with support of Desktop applications and MFC"
Start-Process -FilePath "${msvs_dist}" -ArgumentList `
  ("--locale en-US", `
   "--quiet", `
   "--norestart", `
   "--wait", `
   "--nocache", `
   "--add Microsoft.VisualStudio.Workload.NativeDesktop", `
   "--add Microsoft.VisualStudio.Component.VC.ATLMFC", `
   "--includeRecommended") `
  -Wait
Write-Host "Visual C++ part of Visual Studio 2017 (${env:MSVS_VERSION}) installed"

# Download and install Visual Studio Locator
$vswhere_url = "${env:VSWHERE_URL}/${env:VSWHERE_VERSION}/${env:VSWHERE_EXECTUABLE}"
$vswhere_dist = "${env:SystemRoot}\${env:VSWHERE_DIST_NAME}"
Write-Host "Downloading Visual Studio Locator from ${vswhere_url} into ${vswhere_dist}"
(New-Object System.Net.WebClient).DownloadFile("${vswhere_url}", "${vswhere_dist}")
Write-Host "Visual Studio Locator ${env:VSWHERE_VERSION} installed"

# Cleanup
Write-Host "Removing all files and directories from ${env:TMP}"
Remove-Item -Path "${env:TMP}\*" -Recurse -Force
