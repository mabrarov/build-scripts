#
# Copyright (c) 2022 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

$project_dir = (Get-Item "${PSScriptRoot}").Parent.FullName
$image_repository = "${env:DOCKER_USER}/$(Split-Path "${project_dir}" -Leaf)"

#TODO: add some tests
Write-Host "No tests found for ${image_repository}:latest image"
