#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

$image_version = $(docker inspect abrarov/mingw:latest --format '{{ index .Config.Labels \"version\" }}')

Write-Host "Pushing abrarov/mingw:${image_version} image"
docker push abrarov/mingw:${image_version}

Write-Host "Pushing abrarov/mingw:latest image"
docker push abrarov/mingw:latest
