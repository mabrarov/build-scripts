#
# Copyright (c) 2019 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

$project_dir = (Get-Item "${PSScriptRoot}").Parent.FullName
$image_repository = "${env:DOCKER_USER}/$(Split-Path "${project_dir}" -Leaf)"

Write-Host "Build ICU4C using default configuration and ${image_repository}:latest image"
docker run --rm "${image_repository}:latest"
if (${LastExitCode} -ne 0) {
  throw "Failed to build ICU4C"
}
