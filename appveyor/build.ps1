#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

Write-Host "Building win-builder image"
docker build -t abrarov/win-builder:1.0.0 docker/win-builder

Write-Host "Building mingw image"
docker build -t abrarov/mingw:1.0.3 docker/mingw

Write-Host "Building msvc-2017 image"
docker build -t abrarov/msvc-2017:1.0.2 docker/msvc-2017
