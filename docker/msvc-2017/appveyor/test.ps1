#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

#TODO: find way to deal with tags / versions
$image_tag = "1.0.2"

Write-Host "Get folder where MS Visual Studio 2017 is installed"
docker run --rm abrarov/msvc-2017:${image_tag} vswhere -latest -products Microsoft.VisualStudio.Product.Community -version '[15.0,16.0)' -property installationPath
