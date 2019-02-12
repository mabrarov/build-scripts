#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

#TODO: find way to deal with tags / versions
$image_version = "2.0.0"

Write-Host "Building abrarov/mingw:${image_version} image"
docker build -t abrarov/mingw:${image_version} --build-arg image_version=${image_version} .

Write-Host "Tagging abrarov/mingw:${image_version} image as latest"
docker tag abrarov/mingw:${image_version} abrarov/mingw:latest
