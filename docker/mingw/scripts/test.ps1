#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

$project_dir = (Get-Item "${PSScriptRoot}").Parent.FullName
$image_repository = "${env:DOCKER_USER}/$(Split-Path ${project_dir} -Leaf)"

Write-Host "Get version of MinGW x64 in container created from ${image_repository}:latest image"
docker run --rm "${image_repository}:latest" "C:\mingw64\bin\g++" --version
if (${LastExitCode} -ne 0) {
  throw "Failed to get version of MinGW x64"
}

Write-Host "Get version of MinGW x86 in container created from ${image_repository}:latest image"
docker run --rm "${image_repository}:latest" "C:\mingw32\bin\g++" --version
if (${LastExitCode} -ne 0) {
  throw "Failed to get version of MinGW x86"
}
