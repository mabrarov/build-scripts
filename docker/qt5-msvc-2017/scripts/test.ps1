#
# Copyright (c) 2021 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

$project_dir = (Get-Item "${PSScriptRoot}").Parent.FullName
$image_repository = "${env:DOCKER_USER}/$(Split-Path "${project_dir}" -Leaf)"

Write-Host "Detecting version of Windows SDK in container created from ${image_repository}:latest image"
$windows_sdk_version = $(docker run --rm "${image_repository}:latest" powershell -Command '(Get-ItemProperty -Path ''Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Microsoft SDKs\Windows\v10.0'' -Name ''ProductVersion'').ProductVersion')
if ((${LastExitCode} -ne 0) -or -not "${windows_sdk_version}") {
  throw "Failed to get version of Windows SDK"
}
Write-Host "Detected version of Windows SDK: ${windows_sdk_version}"
$required_version_of_windows_sdk = "10.0.18362"
if ([System.Version] "${windows_sdk_version}" -lt [System.Version] "${required_version_of_windows_sdk}") {
  throw "Detected Windows SDK version is less than ${required_version_of_windows_sdk}: ${windows_sdk_version}"
}

Write-Host "Running Clang in container created from ${image_repository}:latest image"
docker run --rm "${image_repository}:latest" "C:\Program Files\LLVM\bin\clang.exe" --version
if (${LastExitCode} -ne 0) {
  throw "Failed to get version of Clang"
}

Write-Host "Running Jom in container created from ${image_repository}:latest image"
docker run --rm "${image_repository}:latest" "C:\jom\jom.exe" /VERSION
if (${LastExitCode} -ne 0) {
  throw "Failed to get version of Jom"
}

Write-Host "Running Node.js in container created from ${image_repository}:latest image"
docker run --rm "${image_repository}:latest" "C:\node\node.exe" --version
if (${LastExitCode} -ne 0) {
  throw "Failed to get version of Node.js"
}
