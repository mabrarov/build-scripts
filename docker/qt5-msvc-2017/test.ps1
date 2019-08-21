#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

$image_repository = "abrarov/$(Split-Path "${PSScriptRoot}" -Leaf)"

Write-Host "Running jom in container created from ${image_repository}:latest image"
docker run --rm "${image_repository}:latest" "C:\jom\jom" -version
if (${LastExitCode} -ne 0) {
  throw "Failed to get version of jom"
}

Write-Host "Running Clang in container created from ${image_repository}:latest image"
docker run --rm "${image_repository}:latest" "& 'C:\Program Files\LLVM\bin\clang++.exe' --version"
if (${LastExitCode} -ne 0) {
  throw "Failed to get version of Clang"
}
