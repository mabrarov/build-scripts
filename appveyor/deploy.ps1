#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

if (${env:APPVEYOR_PULL_REQUEST_NUMBER} -or -not ${env:APPVEYOR_REPO_BRANCH}.Equals("master")) {
  Write-Host "Nothing to deploy"
  Exit 0
}

Write-Host Starting deploy

# "$env:DOCKER_PASS" | docker login --username "$env:DOCKER_USER" --password-stdin
# docker login with the old config.json style that is needed for manifest-tool
$auth =[System.Text.Encoding]::UTF8.GetBytes("$($env:DOCKER_USER):$($env:DOCKER_PASS)")
$auth64 = [Convert]::ToBase64String($auth)
@"
{
  "auths": {
    "https://index.docker.io/v1/": {
      "auth": "$auth64"
    }
  }
}
"@ | Out-File -Encoding Ascii ~/.docker/config.json

.\docker\win-builder\appveyor\deploy.ps1
.\docker\mingw\appveyor\deploy.ps1
.\docker\msvc-2017\appveyor\deploy.ps1
