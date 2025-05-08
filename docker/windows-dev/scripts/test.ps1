#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

$project_dir = (Get-Item "${PSScriptRoot}").Parent.FullName
$image_repository = "${env:DOCKER_USER}/$(Split-Path "${project_dir}" -Leaf)"

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

Write-Host "Running Git in container created from ${image_repository}:latest image"
docker run --rm "${image_repository}:latest" git --version
if (${LastExitCode} -ne 0) {
  throw "Failed to get version of Git"
}

Write-Host "Running CMake in container created from ${image_repository}:latest image"
docker run --rm "${image_repository}:latest" "C:\cmake\bin\cmake.exe" --version
if (${LastExitCode} -ne 0) {
  throw "Failed to get version of CMake"
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

Write-Host "Running MSYS2 GNU make in container created from ${image_repository}:latest image"
docker run --rm "${image_repository}:latest" "C:\msys64\usr\bin\make" --version
if (${LastExitCode} -ne 0) {
  throw "Failed to get version of MSYS2 GNU make"
}

Write-Host "Running MSYS2 bison in container created from ${image_repository}:latest image"
docker run --rm "${image_repository}:latest" "C:\msys64\usr\bin\bison" --version
if (${LastExitCode} -ne 0) {
  throw "Failed to get version of MSYS2 bison"
}

Write-Host "Running MSYS2 diff in container created from ${image_repository}:latest image"
docker run --rm "${image_repository}:latest" "C:\msys64\usr\bin\diff" --version
if (${LastExitCode} -ne 0) {
  throw "Failed to get version of MSYS2 diff"
}

Write-Host "Running Strawberry Perl in container created from ${image_repository}:latest image"
docker run --rm "${image_repository}:latest" "C:\Perl\perl\bin\perl.exe" --version
if (${LastExitCode} -ne 0) {
  throw "Failed to get version of Strawberry Perl"
}

Write-Host "Running Python 2 in container created from ${image_repository}:latest image"
docker run --rm "${image_repository}:latest" "C:\Python2\python.exe" --version
if (${LastExitCode} -ne 0) {
  throw "Failed to get version of Python 2"
}

Write-Host "Running Python 3 in container created from ${image_repository}:latest image"
docker run --rm "${image_repository}:latest" "C:\Python3\python.exe" --version
if (${LastExitCode} -ne 0) {
  throw "Failed to get version of Python 3"
}

Write-Host "Running Ninja in container created from ${image_repository}:latest image"
docker run --rm "${image_repository}:latest" "C:\ninja\ninja.exe" --version
if (${LastExitCode} -ne 0) {
  throw "Failed to get version of Ninja"
}

Write-Host "Running NASM win64 in container created from ${image_repository}:latest image"
docker run --rm "${image_repository}:latest" "C:\nasm64\nasm.exe" -v
if (${LastExitCode} -ne 0) {
  throw "Failed to get version of NASM win64"
}

Write-Host "Running NASM win32 in container created from ${image_repository}:latest image"
docker run --rm "${image_repository}:latest" "C:\nasm32\nasm.exe" -v
if (${LastExitCode} -ne 0) {
  throw "Failed to get version of NASM win32"
}
