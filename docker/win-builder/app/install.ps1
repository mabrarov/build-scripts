#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

# Enable all versions of TLS
[System.Net.ServicePointManager]::SecurityProtocol = @("Tls12","Tls11","Tls","Ssl3")

# Install Chocolatey package manager
Write-Host "Installing Chocolatey package manager"
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Download and install 7-Zip
$app_dir = "C:\app"
$seven_zip_dist_name = "7z${env:SEVEN_ZIP_VERSION}-x64.msi"
$seven_zip_dist = "${app_dir}\${seven_zip_dist_name}"
if (-not (Test-Path -Path "${seven_zip_dist}")) {
  $seven_zip_url = "${env:SEVEN_ZIP_DOWNLOAD_URL}/${seven_zip_dist_name}"
  Write-Host "Downloading Z-Zip from ${seven_zip_url} into ${seven_zip_dist_name}"
  (New-Object System.Net.WebClient).DownloadFile("${seven_zip_url}", "${seven_zip_dist_name}")
}
Write-Host "Installing Z-Zip from ${seven_zip_dist} into ${env:SEVEN_ZIP_HOME}"
Start-Process -FilePath msiexec -ArgumentList ("/package", "${seven_zip_dist}", "/quiet", "/qn", "/norestart") -Wait

# Download and install ActivePerl
$active_perl_url = "${env:ACTIVE_PERL_URL}/${env:ACTIVE_PERL_VERSION}/ActivePerl-${env:ACTIVE_PERL_VERSION}-MSWin32-x64-${env:ACTIVE_PERL_BUILD}.exe"
Write-Host "Downloading ActivePerl from ${active_perl_url} into ${env:TMP}"
(New-Object System.Net.WebClient).DownloadFile("${active_perl_url}", "${env:TMP}\ActivePerl.exe")
Write-Host "Installing ActivePerl from ${env:TMP}\ActivePerl.exe into ${env:ACTIVE_PERL_HOME}"
Start-Process -FilePath "${env:TMP}\ActivePerl.exe" -ArgumentList ("/exenoui", "/norestart", "/quiet", "/qn") -Wait

# Download and install Python 3.x
$python_dist_url="${env:PYTHON_URL}/${env:PYTHON_VERSION}/python-${env:PYTHON_VERSION}-amd64.exe"
Write-Host "Downloading Python from ${python_dist_url} into ${env:TMP}"
(New-Object System.Net.WebClient).DownloadFile("${python_dist_url}", "${env:TMP}\Python.exe")
Write-Host "Installing Python from ${env:TMP}\Python.exe into ${env:PYTHON_HOME}"
Start-Process -FilePath "${env:TMP}\Python.exe" -ArgumentList ("/exenoui", "/norestart", "/quiet", "/qn", "InstallAllUsers=1") -Wait

# Download and install MSYS2
$msys_tar_filename = "msys2-base-${env:MSYS2_TARGET}-${env:MSYS2_VERSION}.tar"
$msys_dist_filename = "${msys_tar_filename}.xz"
$msys_url = "${env:MSYS2_URL}/${env:MSYS2_TARGET}/${msys_dist_filename}"
$msys_dist = "${env:TMP}\${msys_dist_filename}"
Write-Host "Downloading MSYS2 x64 from ${msys_url} into ${msys_dist}"
(New-Object System.Net.WebClient).DownloadFile("${msys_url}", "${msys_dist}")
Write-Host "Installing MSYS2 x64 into ${env:MSYS_HOME}"
& "${env:SEVEN_ZIP_HOME}\7z.exe" x "${msys_dist}" -o"${env:TMP}" -aoa -y -bd | out-null
& "${env:SEVEN_ZIP_HOME}\7z.exe" x "${env:TMP}\${msys_tar_filename}" -o"C:" -aoa -y -bd | out-null
Write-Host "Starting initialization via msys2_shell.cmd"
Start-Process "${env:MSYS_HOME}\msys2_shell.cmd" -ArgumentList ("-c", "exit") -Wait
& "${env:MSYS_HOME}\usr\bin\bash.exe" -lc 'pacman -S --needed --noconfirm base-devel'

# Cleanup
Write-Host "Removing all files and directories from ${env:TMP}"
Remove-Item -Path "${env:TMP}\*" -Recurse -Force
