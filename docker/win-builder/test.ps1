#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

Write-Host "Running 7-Zip in container created from abrarov/win-builder:latest image"
docker run --rm abrarov/win-builder:latest "C:\Program Files\7-Zip\7z.exe"
