#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

Write-Host "Running jom in container created from abrarov/qt5-msvc-2017:latest image"
docker run --rm abrarov/qt5-msvc-2017:latest "C:\jom\jom" -version
