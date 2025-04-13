#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

$project_dir = (Get-Item "${PSScriptRoot}").Parent.FullName

if (${env:APPVEYOR_PULL_REQUEST_NUMBER} -or -not ${env:APPVEYOR_REPO_BRANCH}.Equals("master")) {
  Write-Host "Nothing to deploy"
  Exit 0
}

Write-Host "Starting deploy"

# "$env:DOCKER_PASS" | docker login --username "$env:DOCKER_USER" --password-stdin
# docker login with the old config.json style that is needed for manifest-tool
$auth =[System.Text.Encoding]::UTF8.GetBytes("$(${env:DOCKER_USER}):$(${env:DOCKER_PASS})")
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

$dirs = @(
  "docker\windows-dev",
  "docker\mingw",
  "docker\mingw-14",
  "docker\msvc-2017",
  "docker\boost-mingw",
  "docker\boost-mingw-14",
  "docker\boost-msvc-2017",
  "docker\openssl-mingw",
  "docker\openssl-msvc-2017",
  "docker\msvc-2019",
  "docker\boost-msvc-2019",
  "docker\openssl-msvc-2019",
  "docker\msvc-2022",
  "docker\boost-msvc-2022",
  "docker\openssl-msvc-2022"
)

${dirs}.GetEnumerator() | ForEach-Object {
  & "${project_dir}\$_\scripts\deploy.ps1"
}
