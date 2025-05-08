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
  "docker\mingw-14",
  "docker\msvc-2017",
  "docker\boost-mingw",
  "docker\boost-mingw-14",
  "docker\boost-msvc-2017",
  "docker\icu-mingw",
  "docker\openssl-mingw",
  "docker\openssl-mingw-14",
  "docker\openssl-msvc-2017",
  "docker\msvc-2019",
  "docker\boost-msvc-2019",
  "docker\icu-msvc-2019",
  "docker\openssl-msvc-2019",
  "docker\msvc-2022",
  "docker\boost-msvc-2022",
  "docker\openssl-msvc-2022",
  "docker\icu-msvc-2022",
  "docker\icu-mingw-14"
)

${dirs}.GetEnumerator() | ForEach-Object {
  & "${project_dir}\$_\scripts\test.ps1"
}
