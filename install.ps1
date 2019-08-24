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
if (${LastExitCode} -ne 0) {
  throw "Failed to connect to Docker Engine"
}

if ((Test-Path env:TRAVIS) -and (${env:TRAVIS} -eq "true")) {
  # Travis uses Windows 17134.1.amd64fre.rs4_release.180410-1804 which cannot run
  # microsoft/windowsservercore:10.0.14393.1198 Docker image
  # We cannot use ARG before FROM in win-builder Dockerfile due to old version of Docker,
  # so let's trick Travis by tagging microsoft/windowsservercore:10.0.17134.950 Docker image
  # as microsoft/windowsservercore:10.0.14393.1198
  $windows_image_repository = "microsoft/windowsservercore"
  $required_windows_image_version = "ltsc2016"
  $travis_supported_windows_image_version = "1803"
  Write-Host "List of Docker images"
  docker images
  if (${LastExitCode} -ne 0) {
    throw "Failed to list Docker images"
  }
#  docker pull "${windows_image_repository}:${travis_supported_windows_image_version}"
#  if (${LastExitCode} -ne 0) {
#    throw "Failed to pull ${windows_image_repository}:${travis_supported_windows_image_version} image"
#  }
  Write-Host "Re-tagging ${windows_image_repository}:${travis_supported_windows_image_version} image as ${required_windows_image_version}"
  docker tag `
    "${windows_image_repository}:${travis_supported_windows_image_version}" `
    "${windows_image_repository}:${required_windows_image_version}"
  if (${LastExitCode} -ne 0) {
    throw "Failed to re-tag ${windows_image_repository}:${travis_supported_windows_image_version} image as ${required_windows_image_version}"
  }
  docker images
  if (${LastExitCode} -ne 0) {
    throw "Failed to list Docker images"
  }
  docker run --rm "${windows_image_repository}:${required_windows_image_version}" cmd /c echo "Hello, World!"
  if (${LastExitCode} -ne 0) {
    throw "Failed to run ${windows_image_repository}:${required_windows_image_version} image"
  }
}
