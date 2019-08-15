#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

Write-Host "Running 7-Zip in container created from abrarov/win-builder:latest image"
docker run --rm abrarov/win-builder:latest "C:\Program Files\7-Zip\7z.exe"

Write-Host "Running MSYS2 GNU make in container created from abrarov/win-builder:latest image"
docker run --rm abrarov/win-builder:latest "C:\msys64\usr\bin\make" --version
Write-Host "Running MSYS2 GNU tar in container created from abrarov/win-builder:latest image"
docker run --rm abrarov/win-builder:latest "C:\msys64\usr\bin\tar" --version
Write-Host "Running MSYS2 GNU patch in container created from abrarov/win-builder:latest image"
docker run --rm abrarov/win-builder:latest "C:\msys64\usr\bin\patch" --version

Write-Host "Running ActivePerl in container created from abrarov/win-builder:latest image"
docker run --rm abrarov/win-builder:latest "C:\Perl64\bin\perl.exe" --version

Write-Host "Running Python in container created from abrarov/win-builder:latest image"
docker run --rm abrarov/win-builder:latest "C:\Program Files\Python37\python.exe" --version
