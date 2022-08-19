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
$env:chocolateyUseWindowsCompression = 'true'
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
Write-Host "Chocolatey package manager installed"

# Download and install 7-Zip
$seven_zip_version_suffix = "${env:SEVEN_ZIP_VERSION}" -replace "\.", ""
$seven_zip_dist_name = "7z${seven_zip_version_suffix}-x64.msi"
$seven_zip_dist = "${PSScriptRoot}\${seven_zip_dist_name}"
if (-not (Test-Path -Path "${seven_zip_dist}")) {
  $seven_zip_dist = "${env:TMP}\${seven_zip_dist_name}"
  $seven_zip_url = "${env:SEVEN_ZIP_DOWNLOAD_URL}/${seven_zip_dist_name}"
  Write-Host "Downloading 7-Zip from ${seven_zip_url} into ${seven_zip_dist}"
  (New-Object System.Net.WebClient).DownloadFile("${seven_zip_url}", "${seven_zip_dist}")
}
Write-Host "Installing 7-Zip from ${seven_zip_dist} into ${env:SEVEN_ZIP_HOME}"
$p = Start-Process -FilePath "${seven_zip_dist}" `
  -ArgumentList ("/norestart", "/quiet", "/qn", "ALLUSERS=1", "TargetDir=""${env:SEVEN_ZIP_HOME}""") `
  -Wait -PassThru
if (${p}.ExitCode -ne 0) {
  throw "Failed to install 7-Zip"
}
Write-Host "7-Zip ${env:SEVEN_ZIP_VERSION} installed into ${env:SEVEN_ZIP_HOME}"

# Install Git for Windows
& choco install git -y --no-progress --version "${env:GIT_VERSION}" --force -params "'/NoShellIntegration /NoGuiHereIntegration /NoShellHereIntegration'"
if (${LastExitCode} -ne 0) {
  throw "Failed to install Git ${env:GIT_VERSION}"
}
Write-Host "Git ${env:GIT_VERSION} installed"

if ([System.Version] "${env:CMAKE_VERSION}" -ge [System.Version] "3.20.0") {
  $cmake_dist_base_name = "cmake-${env:CMAKE_VERSION}-windows-x86_64"
} else {
  if ([System.Version] "${env:CMAKE_VERSION}" -ge [System.Version] "3.6.0") {
    $cmake_dist_base_name = "cmake-${env:CMAKE_VERSION}-win64-x64"
  } else {
    # CMake x64 binary is not available for CMake version < 3.6.0
    $cmake_dist_base_name = "cmake-${env:CMAKE_VERSION}-win32-x86"
  }
}
$cmake_dist_name = "${cmake_dist_base_name}.zip"
$cmake_dist = "${env:TMP}\${cmake_dist_name}"
$cmake_url = "${env:CMAKE_URL}/v${env:CMAKE_VERSION}/${cmake_dist_name}"
Write-Host "Downloading CMake from ${cmake_url} into ${cmake_dist}"
(New-Object System.Net.WebClient).DownloadFile("${cmake_url}", "${cmake_dist}")
$cmake_temp_dir = "${env:TMP}\${cmake_dist_base_name}"
Write-Host "Extracting CMake from ${cmake_dist} into ${cmake_temp_dir}"
& "${env:SEVEN_ZIP_HOME}\7z.exe" x "${cmake_dist}" -o"${env:TMP}" -aoa -y -bd | out-null
Write-Host "Moving CMake from ${cmake_temp_dir} into ${env:CMAKE_HOME}"
[System.IO.Directory]::Move("${cmake_temp_dir}", "${env:CMAKE_HOME}")
Write-Host "CMake ${env:CMAKE_VERSION} installed into ${env:CMAKE_HOME}"

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
& "${PSScriptRoot}\msys2.bat"
Write-Host "MSYS2 ${env:MSYS2_VERSION} installed into ${env:MSYS_HOME}"

# Download and install Strawberry Perl
$strawberry_perl_dist_name = "strawberry-perl-${env:STRAWBERRY_PERL_VERSION}-64bit.msi"
$strawberry_perl_url = "${env:STRAWBERRY_PERL_URL}/${env:STRAWBERRY_PERL_VERSION}/${strawberry_perl_dist_name}"
$strawberry_perl_dist = "${env:TMP}\${strawberry_perl_dist_name}"
Write-Host "Downloading Strawberry Perl from ${strawberry_perl_url} into ${strawberry_perl_dist}"
(New-Object System.Net.WebClient).DownloadFile("${strawberry_perl_url}", "${strawberry_perl_dist}")
Write-Host "Installing Strawberry Perl from ${strawberry_perl_dist} into ${env:STRAWBERRY_PERL_HOME}"
$p = Start-Process -FilePath "${strawberry_perl_dist}" `
  -ArgumentList ("/norestart", "/quiet", "/qn", "INSTALLDIR=""${env:STRAWBERRY_PERL_HOME}\""") `
  -Wait -PassThru
if (${p}.ExitCode -ne 0) {
  throw "Failed to install Strawberry Perl"
}
Write-Host "Strawberry Perl ${env:STRAWBERRY_PERL_VERSION} installed into ${env:STRAWBERRY_PERL_HOME}"

# Download and install Python 2.x
$python_dist_name = "python-${env:PYTHON2_VERSION}.amd64.msi"
$python_dist_url = "${env:PYTHON_URL}/${env:PYTHON2_VERSION}/${python_dist_name}"
$python_dist = "${env:TMP}\${python_dist_name}"
Write-Host "Downloading Python ${env:PYTHON2_VERSION} from ${python_dist_url} into ${python_dist}"
(New-Object System.Net.WebClient).DownloadFile("${python_dist_url}", "${python_dist}")
Write-Host "Installing Python ${env:PYTHON2_VERSION} from ${python_dist} into ${env:PYTHON2_HOME}"
$p = Start-Process -FilePath "${python_dist}" `
  -ArgumentList ("/norestart", "/quiet", "/qn", "ALLUSERS=1", "TargetDir=""${env:PYTHON2_HOME}""") `
  -Wait -PassThru
if (${p}.ExitCode -ne 0) {
  throw "Failed to install Python ${env:PYTHON2_VERSION}"
}
Write-Host "Python ${env:PYTHON2_VERSION} installed into ${env:PYTHON2_HOME}"

# Download and install Python 3.x
$python_dist_name = "python-${env:PYTHON3_VERSION}-amd64.exe"
$python_dist_url = "${env:PYTHON_URL}/${env:PYTHON3_VERSION}/${python_dist_name}"
$python_dist = "${env:TMP}\${python_dist_name}"
Write-Host "Downloading Python ${env:PYTHON3_VERSION} from ${python_dist_url} into ${python_dist}"
(New-Object System.Net.WebClient).DownloadFile("${python_dist_url}", "${python_dist}")
Write-Host "Installing Python ${env:PYTHON3_VERSION} from ${python_dist} into ${env:PYTHON3_HOME}"
$p = Start-Process -FilePath "${python_dist}" `
  -ArgumentList ("/exenoui", "/norestart", "/quiet", "/qn", "InstallAllUsers=1", "TargetDir=""${env:PYTHON3_HOME}""") `
  -Wait -PassThru
if (${p}.ExitCode -ne 0) {
  throw "Failed to install Python ${env:PYTHON3_VERSION}"
}
Write-Host "Python ${env:PYTHON3_VERSION} installed into ${env:PYTHON3_HOME}"

# Download and install Ninja
$ninja_dist_name = "ninja-win.zip"
$ninja_dist_url = "${env:NINJA_URL}/v${env:NINJA_VERSION}/${ninja_dist_name}"
$ninja_dist = "${env:TMP}\${ninja_dist_name}"
Write-Host "Downloading Ninja ${env:NINJA_VERSION} from ${ninja_dist_url} into ${ninja_dist}"
(New-Object System.Net.WebClient).DownloadFile("${ninja_dist_url}", "${ninja_dist}")
New-Item -Path "${env:NINJA_HOME}" -ItemType "directory" | out-null
Write-Host "Extracting Ninja from ${ninja_dist} into ${env:NINJA_HOME} directory"
& "${env:SEVEN_ZIP_HOME}\7z.exe" x "${ninja_dist}" -o"${env:NINJA_HOME}" -aoa -y -bd | out-null
Write-Host "Ninja ${env:NINJA_VERSION} installed into ${env:NINJA_HOME}"

# Cleanup
Write-Host "Removing all files and directories from ${env:TMP}"
Remove-Item -Path "${env:TMP}\*" -Recurse -Force
