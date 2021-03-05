#
# Copyright (c) 2021 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

$project_dir = (Get-Item "${PSScriptRoot}").Parent.FullName
$image_repository = "${env:DOCKER_USER}/$(Split-Path "${project_dir}" -Leaf)"

Write-Host "Running Clang in container created from ${image_repository}:latest image"
docker run --rm "${image_repository}:latest" "C:\Program Files\LLVM\bin\clang" --version
if (${LastExitCode} -ne 0) {
  throw "Failed to get version of Clang"
}

Write-Host "Running Jom in container created from ${image_repository}:latest image"
docker run --rm "${image_repository}:latest" "C:\jom\jom.exe" /VERSION
if (${LastExitCode} -ne 0) {
  throw "Failed to get version of Jom"
}

Write-Host "Running Node.js in container created from ${image_repository}:latest image"
docker run --rm "${image_repository}:latest" "C:\node\node" --version
if (${LastExitCode} -ne 0) {
  throw "Failed to get version of Node.js"
}
