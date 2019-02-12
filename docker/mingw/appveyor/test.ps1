#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

#TODO: find way to deal with tags / versions
$image_tag = "1.0.3"

Write-Host "Get version of MinGW x64"
docker run --rm abrarov/mingw:${image_tag} "C:\mingw64\bin\g++" --version

Write-Host "Get version of MinGW x86"
docker run --rm abrarov/mingw:${image_tag} "C:\mingw32\bin\g++" --version
