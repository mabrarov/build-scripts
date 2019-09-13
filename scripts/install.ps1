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
  # Travis CI uses Windows 17134.1.amd64fre.rs4_release.180410-1804 which cannot run
  # mcr.microsoft.com/windows/servercore:ltsc2019 Docker image.
  # We cannot use ARG before FROM in windows-dev Dockerfile due to old version of Docker.
  # Let's trick Travis CI by tagging microsoft/windowsservercore:1803 Docker image, which Travis CI already has
  # in its Docker Engine, as mcr.microsoft.com/windows/servercore:ltsc2019

  $windows_image_repository = "mcr.microsoft.com/windows/servercore"
  $windows_image_version = "ltsc2019"
  $travis_windows_image_repository = "microsoft/windowsservercore"
  $travis_windows_image_version = "1803"

  Write-Host "List of Docker images"
  docker images
  if (${LastExitCode} -ne 0) {
    throw "Failed to list Docker images"
  }

  docker inspect --type image "${travis_windows_image_repository}:${travis_windows_image_version}" *> $null
  if (${LastExitCode} -ne 0) {
    Write-Host "${travis_windows_image_repository}:${travis_windows_image_version} image not found, pulling it..."
    docker pull "${travis_windows_image_repository}:${travis_windows_image_version}"
    if (${LastExitCode} -ne 0) {
      throw "Failed to pull ${travis_windows_image_repository}:${travis_windows_image_version} image"
    }
  }

  Write-Host "Re-tagging ${travis_windows_image_repository}:${travis_windows_image_version} image as ${windows_image_repository}:${windows_image_version}"
  docker tag `
    "${travis_windows_image_repository}:${travis_windows_image_version}" `
    "${windows_image_repository}:${windows_image_version}"
  if (${LastExitCode} -ne 0) {
    throw "Failed to re-tag ${travis_windows_image_repository}:${travis_windows_image_version} image as ${windows_image_repository}:${windows_image_version}"
  }

  docker images
  if (${LastExitCode} -ne 0) {
    throw "Failed to list Docker images"
  }

  Write-Host "Testing if Travis CI Docker is able to run containers created from ${windows_image_repository}:${windows_image_version} image"
  docker run --rm "${windows_image_repository}:${windows_image_version}" cmd /c "echo Container run successfully"
  if (${LastExitCode} -ne 0) {
    throw "Failed to run ${windows_image_repository}:${windows_image_version} image"
  }
}
