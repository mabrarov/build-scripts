#
# Copyright (c) 2021 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

$project_dir = (Get-Item "${PSScriptRoot}").Parent.FullName
$image_repository = "${env:DOCKER_USER}/$(Split-Path "${project_dir}" -Leaf)"

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
