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
Write-Host "Chocolatey package manager installed"

# Download and install 7-Zip
$app_dir = "C:\app"
$seven_zip_version_suffix = "${env:SEVEN_ZIP_VERSION}" -replace "\.", ""
$seven_zip_dist_name = "7z${seven_zip_version_suffix}-x64.msi"
$seven_zip_dist = "${app_dir}\${seven_zip_dist_name}"
if (-not (Test-Path -Path "${seven_zip_dist}")) {
  $seven_zip_url = "${env:SEVEN_ZIP_DOWNLOAD_URL}/${seven_zip_dist_name}"
  Write-Host "Downloading Z-Zip from ${seven_zip_url} into ${seven_zip_dist_name}"
  (New-Object System.Net.WebClient).DownloadFile("${seven_zip_url}", "${seven_zip_dist_name}")
}
Write-Host "Installing Z-Zip from ${seven_zip_dist} into ${env:SEVEN_ZIP_HOME}"
Start-Process -FilePath msiexec `
  -ArgumentList ("/package", "${seven_zip_dist}", "/quiet", "/qn", "/norestart") `
  -Wait
Write-Host "Z-Zip ${env:SEVEN_ZIP_VERSION} installed"

# Download and install MSYS2
$msys_tar_name = "msys2-base-${env:MSYS2_TARGET}-${env:MSYS2_VERSION}.tar"
$msys_dist_name = "${msys_tar_name}.xz"
$msys_url = "${env:MSYS2_URL}/${env:MSYS2_TARGET}/${msys_dist_name}"
$msys_dist = "${env:TMP}\${msys_dist_name}"
Write-Host "Downloading MSYS2 from ${msys_url} into ${msys_dist}"
(New-Object System.Net.WebClient).DownloadFile("${msys_url}", "${msys_dist}")
Write-Host "Extracting MSYS2 from ${msys_dist} into ${env:MSYS_HOME}"
& "${env:SEVEN_ZIP_HOME}\7z.exe" x "${msys_dist}" -o"${env:TMP}" -aoa -y -bd | out-null
& "${env:SEVEN_ZIP_HOME}\7z.exe" x "${env:TMP}\${msys_tar_name}" -o"C:" -aoa -y -bd | out-null
& "${app_dir}\msys2.bat"
Write-Host "MSYS2 ${env:MSYS2_VERSION} installed"

# Download and install ActivePerl
$active_perl_dist_name = "ActivePerl-${env:ACTIVE_PERL_VERSION}-MSWin32-x64-${env:ACTIVE_PERL_BUILD}.exe"
$active_perl_url = "${env:ACTIVE_PERL_URL}/${env:ACTIVE_PERL_VERSION}/${active_perl_dist_name}"
$active_perl_dist = "${env:TMP}\${active_perl_dist_name}"
Write-Host "Downloading ActivePerl from ${active_perl_url} into ${active_perl_dist}"
(New-Object System.Net.WebClient).DownloadFile("${active_perl_url}", "${active_perl_dist}")
Write-Host "Installing ActivePerl from ${active_perl_dist} into ${env:ACTIVE_PERL_HOME}"
Start-Process -FilePath "${active_perl_dist}" -ArgumentList ("/exenoui", "/norestart", "/quiet", "/qn") -Wait
Write-Host "ActivePerl ${env:ACTIVE_PERL_VERSION} installed"

# Download and install Python 3.x
$python_dist_name = "python-${env:PYTHON_VERSION}-amd64.exe"
$python_dist_url = "${env:PYTHON_URL}/${env:PYTHON_VERSION}/${python_dist_name}"
$python_dist = "${env:TMP}\${python_dist_name}"
Write-Host "Downloading Python from ${python_dist_url} into ${python_dist}"
(New-Object System.Net.WebClient).DownloadFile("${python_dist_url}", "${python_dist}")
Write-Host "Installing Python from ${python_dist} into ${env:PYTHON_HOME}"
Start-Process -FilePath "${python_dist}" `
  -ArgumentList ("/exenoui", "/norestart", "/quiet", "/qn", "InstallAllUsers=1") `
  -Wait
Write-Host "Python ${env:PYTHON_VERSION} installed"

# Cleanup
Write-Host "Removing all files and directories from ${env:TMP}"
Remove-Item -Path "${env:TMP}\*" -Recurse -Force
