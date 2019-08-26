#
# Copyright (c) 2019 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

$project_dir = (Get-Item "${PSScriptRoot}").Parent.FullName
$image_repository = "${env:DOCKER_USER}/$(Split-Path "${project_dir}" -Leaf)"

Write-Host "Get folder where MS Visual Studio 2015 is installed in container created from ${image_repository}:latest image"
docker run --rm "${image_repository}:latest" vswhere -legacy -latest -version '[14.0,15.0)' -property installationPath
if (${LastExitCode} -ne 0) {
  throw "Failed to get folder where MS Visual Studio 2015 is installed"
}
