#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

$dirs = @(
  "docker/win-builder",
  "docker/mingw",
  "docker/msvc-2017",
  "docker/boost-mingw",
  "docker/boost-msvc-2017",
  "docker/icu-mingw",
  "docker/icu-msvc-2017",
  "docker/openssl-mingw",
  "docker/openssl-msvc-2017"
)

${dirs}.GetEnumerator() | ForEach-Object {
  & "${PSScriptRoot}\$_\build.ps1"
}

docker images
