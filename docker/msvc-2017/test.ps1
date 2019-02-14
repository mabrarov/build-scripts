#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

Write-Host "Get folder where MS Visual Studio 2017 is installed in container created from abrarov/msvc-2017:latest image"
docker run --rm abrarov/msvc-2017:latest vswhere -latest -products Microsoft.VisualStudio.Product.Community -version '[15.0,16.0)' -property installationPath
