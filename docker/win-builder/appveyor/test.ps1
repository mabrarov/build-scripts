#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

#TODO: find way to deal with tags / versions
$image_tag = "1.0.0"

Write-Host "Running 7-Zip in container created from abrarov/win-builder:${image_tag} image"
docker run --rm abrarov/win-builder:${image_tag} "C:\Program Files\7-Zip\7z.exe"
