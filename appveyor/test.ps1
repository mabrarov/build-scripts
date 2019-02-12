#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

.\docker\win-builder\appveyor\test.ps1
.\docker\mingw\appveyor\test.ps1
.\docker\msvc-2017\appveyor\test.ps1
