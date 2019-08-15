#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

# Enable all versions of TLS
[System.Net.ServicePointManager]::SecurityProtocol = @("Tls12","Tls11","Tls","Ssl3")

# Download MinGW x64
$mingw64_dist_name = "${env:MINGW_64_TARGET}-${env:MINGW_VERSION}-release-${env:MINGW_64_THREADS}-${env:MINGW_64_EXCEPTIONS}-rt_v${env:MINGW_RT_FILE_SUFFIX}-rev${env:MINGW_REVISON}.7z"
$mingw64_url = "${env:MINGW_URL}/${env:MINGW_64_TOOLCHAIN_PATH}/${env:MINGW_VERSION}/threads-${env:MINGW_64_THREADS}/${env:MINGW_64_EXCEPTIONS}/${mingw64_dist_name}${env:mingw64_url_POSTFIX}"
$mingw64_dist = "${env:TMP}\${mingw64_dist_name}"
Write-Host "Downloading MinGW x64 from ${mingw64_url} into ${mingw64_dist}"
(New-Object System.Net.WebClient).DownloadFile("${mingw64_url}", "${mingw64_dist}")
# Extract MinGW x64 and install it into C:\mingw64
Write-Host "Extracting MinGW x64 from ${mingw64_dist} into ${env:MINGW64_HOME}"
"${env:SEVEN_ZIP_HOME}\7z.exe" x "${mingw64_dist}" -o"C:" -aoa -y -bd | out-null
Write-Host "MinGW x64 ${env:MINGW_VERSION} installed"

# Download MinGW x86
$mingw32_dist_name = "${env:MINGW_32_TARGET}-${env:MINGW_VERSION}-release-${env:MINGW_32_THREADS}-${env:MINGW_32_EXCEPTIONS}-rt_v${env:MINGW_RT_FILE_SUFFIX}-rev${env:MINGW_REVISON}.7z"
$mingw32_url = "${env:MINGW_URL}/${env:MINGW_32_TOOLCHAIN_PATH}/${env:MINGW_VERSION}/threads-${env:MINGW_32_THREADS}/${env:MINGW_32_EXCEPTIONS}/${mingw32_dist_name}${env:mingw32_url_POSTFIX}"
$mingw32_dist = "${env:TMP}\${mingw32_dist_name}"
Write-Host "Downloading MinGW x86 from ${mingw32_url} into ${mingw32_dist}"
(New-Object System.Net.WebClient).DownloadFile("${mingw32_url}", "${mingw32_dist}")
# Extract MinGW x64 and install it into C:\mingw32
Write-Host "Extracting MinGW x86 from ${mingw32_dist} into ${env:MINGW32_HOME}"
"${env:SEVEN_ZIP_HOME}\7z.exe" x "${mingw32_dist}" -o"C:" -aoa -y -bd | out-null
Write-Host "MinGW x86 ${env:MINGW_VERSION} installed"

# Cleanup
Write-Host "Removing all files and directories from ${env:TMP}"
Remove-Item -Path "${env:TMP}\*" -Recurse -Force
