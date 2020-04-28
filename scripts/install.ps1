#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

$docker_host_win_version = $(gp 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').BuildLabEx
Write-Host "Windows version ${docker_host_win_version}"

docker version
if (${LastExitCode} -ne 0) {
  throw "Failed to connect to Docker Engine"
}

if ((Test-Path env:TRAVIS) -and (${env:TRAVIS} -eq "true")) {
  $windows_image_repository = "mcr.microsoft.com/windows/servercore"
  $windows_image_version = "ltsc2019"

  Write-Host "List of Docker images"
  docker images
  if (${LastExitCode} -ne 0) {
    throw "Failed to list Docker images"
  }

  docker inspect --type image "${windows_image_repository}:${windows_image_version}" *> $null
  if (${LastExitCode} -ne 0) {
    Write-Host "${windows_image_repository}:${windows_image_version} image not found, pulling it..."
    docker pull "${windows_image_repository}:${windows_image_version}"
    if (${LastExitCode} -ne 0) {
      throw "Failed to pull ${windows_image_repository}:${windows_image_version} image"
    }
    docker images
    if (${LastExitCode} -ne 0) {
      throw "Failed to list Docker images"
    }
  }

  Write-Host "Testing if Travis CI Docker is able to run containers created from ${windows_image_repository}:${windows_image_version} image"
  docker run --rm "${windows_image_repository}:${windows_image_version}" cmd /c "echo Container run successfully"
  if (${LastExitCode} -ne 0) {
    throw "Failed to run ${windows_image_repository}:${windows_image_version} image"
  }
}
