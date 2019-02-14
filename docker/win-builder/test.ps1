#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

Write-Host "Running 7-Zip in container created from abrarov/win-builder:latest image"
docker run --rm abrarov/win-builder:latest "`${env:SEVEN_ZIP_HOME}/7z.exe"

Write-Host "Running MSYS2 GNU make in container created from abrarov/win-builder:latest image"
docker run --rm abrarov/win-builder:latest "`${env:MSYS_HOME}\usr\bin\make" --version

Write-Host "Running ActivePerl in container created from abrarov/win-builder:latest image"
docker run --rm abrarov/win-builder:latest "`${env:ACTIVE_PERL_HOME}\bin\perl.exe" --version

Write-Host "Running Python in container created from abrarov/win-builder:latest image"
docker run --rm abrarov/win-builder:latest "`${env:PYTHON_HOME}\bin\python.exe" --version
