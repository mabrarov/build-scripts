#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

$image_repository = "abrarov/$(Split-Path "${PSScriptRoot}" -Leaf)"

$image_version = $(docker inspect "${image_repository}:latest" --format '{{ index .Config.Labels \"version\" }}')
Write-Host "Detected version of ${image_repository}:latest image is ${image_version}"

Write-Host "Pushing ${image_repository}:${image_version} image"
docker push "${image_repository}:${image_version}"
if (${LastExitCode} -ne 0) {
  throw "Failed to push ${image_repository}:${image_version} image"
}

Write-Host "Pushing ${image_repository}:latest image"
docker push "${image_repository}:latest"
if (${LastExitCode} -ne 0) {
  throw "Failed to push ${image_repository}:latest image"
}
