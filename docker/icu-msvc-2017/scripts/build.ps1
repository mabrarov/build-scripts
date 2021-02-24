#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

$project_dir = (Get-Item "${PSScriptRoot}").Parent.FullName
$image_repository = "${env:DOCKER_USER}/$(Split-Path "${project_dir}" -Leaf)"
#TODO: find way to deal with tags and versions
$image_version = "2.11.0"
$image_revision = "$(git -C "${project_dir}" rev-parse --verify HEAD)"

Write-Host "Building ${image_repository}:${image_version} image with ${image_revision} revision"
docker build `
  -t "${image_repository}:${image_version}" `
  --build-arg "image_version=${image_version}" `
  --build-arg "image_revision=${image_revision}" `
  "${project_dir}\src"
if (${LastExitCode} -ne 0) {
  throw "Failed to build ${image_repository} image"
}

Write-Host "Tagging ${image_repository}:${image_version} image as latest"
docker tag "${image_repository}:${image_version}" "${image_repository}:latest"
if (${LastExitCode} -ne 0) {
  throw "Failed to tag ${image_repository}:${image_version} image as ${image_repository}:latest"
}
