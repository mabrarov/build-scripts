#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

$project_dir = (Get-Item "${PSScriptRoot}").Parent.FullName

$dirs = @(
  "docker\windows-dev",
  "docker\mingw",
  "docker\msvc-2017",
  "docker\boost-mingw",
  "docker\boost-msvc-2017",
  "docker\icu-mingw",
  "docker\icu-msvc-2017",
  "docker\openssl-mingw",
  "docker\openssl-msvc-2017",
  "docker\msvc-2015",
  "docker\boost-msvc-2015",
  "docker\icu-msvc-2015",
  "docker\openssl-msvc-2015",
  "docker\msvc-2019",
  "docker\boost-msvc-2019",
  "docker\icu-msvc-2019",
  "docker\openssl-msvc-2019",
  "docker\qt5-mingw",
  "docker\qt5-msvc-2017",
  "docker\qt5-msvc-2019"
)

${dirs}.GetEnumerator() | ForEach-Object {
  & "${project_dir}\$_\scripts\build.ps1"
}

docker images
