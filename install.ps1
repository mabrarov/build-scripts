#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

$docker_host_win_version = $(gp 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').BuildLabEx
Write-Host "Windows version ${docker_host_win_version}"

docker version
