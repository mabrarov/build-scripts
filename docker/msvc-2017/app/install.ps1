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
Write-Host "Downloading Visual Studio 2017 Community edition from ${env:MSVS_INSTALL_URL} into ${env:TMP} directory"
(New-Object System.Net.WebClient).DownloadFile("${env:MSVS_INSTALL_URL}", "${env:TMP}\${env:MSVS_INSTALL_EXECUTABLE}")

# Install Visual C++ part of Visual Studio 2017 Community edition
Write-Host "Installing Visual C++ part of Visual Studio 2017 Community edition with support of Desktop applications and MFC"
Start-Process -FilePath "${env:TMP}\${env:MSVS_INSTALL_EXECUTABLE}" -ArgumentList ("--locale en-US", "--quiet", "--norestart", "--wait", "--nocache", "--add Microsoft.VisualStudio.Workload.NativeDesktop", "--add Microsoft.VisualStudio.Component.VC.ATLMFC", "--includeRecommended") -Wait

# Download and install Visual Studio Locator
$vswhere_ful_url = "${env:VSWHERE_RELEASE_URL}/${env:VSWHERE_VERSION}/${env:VSWHERE_EXECTUABLE}"
Write-Host "Downloading Visual Studio Locator from ${vswhere_ful_url} into ${env:SystemRoot}"
(New-Object System.Net.WebClient).DownloadFile("${vswhere_ful_url}", "${env:SystemRoot}\${env:VSWHERE_EXECTUABLE}")

# Cleanup
Write-Host "Removing all files and directories from ${env:TMP}"
Remove-Item -Path "${env:TMP}\*" -Recurse -Force
