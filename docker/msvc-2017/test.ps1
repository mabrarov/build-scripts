#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

$image_repository = "abrarov/$(Split-Path "${PSScriptRoot}" -Leaf)"

Write-Host "Get folder where MS Visual Studio 2017 is installed in container created from ${image_repository}:latest image"
docker run --rm "${image_repository}:latest" ^
vswhere -latest -products Microsoft.VisualStudio.Product.Community -version '[15.0,16.0)' -property installationPath
if (${LastExitCode} -ne 0) {
  throw "Failed to get folder where MS Visual Studio 2017 is installed"
}
