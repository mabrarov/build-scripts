#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

$image_repository = "${env:DOCKER_USER}/$(Split-Path "${PSScriptRoot}" -Leaf)"

Write-Host "Running Chocolatey package manager in container created from ${image_repository}:latest image"
docker run --rm "${image_repository}:latest" choco --version
if (${LastExitCode} -ne 0) {
  throw "Failed to get version of Chocolatey package manager"
}

Write-Host "Running 7-Zip in container created from ${image_repository}:latest image"
docker run --rm "${image_repository}:latest" "C:\Program Files\7-Zip\7z.exe" i
if (${LastExitCode} -ne 0) {
  throw "Failed to get help from 7-Zip command line utility"
}

Write-Host "Running MSYS2 GNU Make in container created from ${image_repository}:latest image"
docker run --rm "${image_repository}:latest" "C:\msys64\usr\bin\make" --version
if (${LastExitCode} -ne 0) {
  throw "Failed to get version of MSYS2 GNU Make"
}

Write-Host "Running MSYS2 GNU tar in container created from ${image_repository}:latest image"
docker run --rm "${image_repository}:latest" "C:\msys64\usr\bin\tar" --version
if (${LastExitCode} -ne 0) {
  throw "Failed to get version of MSYS2 GNU tar"
}

Write-Host "Running MSYS2 GNU patch in container created from ${image_repository}:latest image"
docker run --rm "${image_repository}:latest" "C:\msys64\usr\bin\patch" --version
if (${LastExitCode} -ne 0) {
  throw "Failed to get version of MSYS2 GNU patch"
}

Write-Host "Running ActivePerl in container created from ${image_repository}:latest image"
docker run --rm "${image_repository}:latest" "C:\Perl64\bin\perl.exe" --version
if (${LastExitCode} -ne 0) {
  throw "Failed to get version of ActivePerl"
}

Write-Host "Running Python 2 in container created from ${image_repository}:latest image"
docker run --rm "${image_repository}:latest" "C:\Python27\python.exe" --version
if (${LastExitCode} -ne 0) {
  throw "Failed to get version of Python 2"
}

Write-Host "Running Python 3 in container created from ${image_repository}:latest image"
docker run --rm "${image_repository}:latest" "C:\Python37\python.exe" --version
if (${LastExitCode} -ne 0) {
  throw "Failed to get version of Python 3"
}
