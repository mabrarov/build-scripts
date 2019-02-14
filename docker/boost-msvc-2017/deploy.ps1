#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

$image_version = $(docker inspect abrarov/boost-msvc-2017:latest --format '{{ index .Config.Labels \"version\" }}')

Write-Host "Pushing abrarov/boost-msvc-2017:${image_version} image"
docker push abrarov/boost-msvc-2017:${image_version}

Write-Host "Pushing abrarov/boost-msvc-2017:latest image"
docker push abrarov/boost-msvc-2017:latest
