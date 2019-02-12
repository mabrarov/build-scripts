#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

Write-Host "Windows version: $(gp 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').BuildLabEx"

docker version
