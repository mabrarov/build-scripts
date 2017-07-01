#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the Boost Software License, Version 1.0. (See accompanying
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

# Location of MinGW
$env:MINGW64_HOME = "C:\mingw64"
$env:MINGW32_HOME = "C:\mingw32"

$qt_version_underscore = "$env:QT_VERSION" -replace "\.", '_'
$qt_archive_file = "$env:DOWNLOAD_DIR\icu4c-$qt_version_underscore-src.zip"
$qt_download_url = "$env:QT_URL/$env:QT_VERSION/icu4c-$qt_version_underscore-src.zip"

# Build Qt
$address_models = @("64", "32")
$qt_linkages = @("shared", "static")

# Limit build configurations if user asked for that
if (Test-Path env:QT_ADDRESS_MODEL) {
  $address_models = @("$env:QT_ADDRESS_MODEL")
}
if (Test-Path env:QT_LINKAGE) {
  $qt_linkages = @("$env:QT_LINKAGE")
}

$mingw_version_suffix = "$env:MINGW_VERSION" -replace "\.", ''
$qt_downloaded = "False"

foreach ($address_model in $address_models) {
  $env:QT_ADDRESS_MODEL = $address_model

  # Determine parameters dependent on address model
  switch ($env:QT_ADDRESS_MODEL) {
    "32" {
      $env:MINGW_HOME = "$env:MINGW32_HOME"
      $address_model_target_dir_suffix = "x86"
      $env:QT_BUILD_MACHINE = "i686-w64-mingw32"
    }
    "64" {
      $env:MINGW_HOME = "$env:MINGW64_HOME"
      $address_model_target_dir_suffix = "x64"
      $env:QT_BUILD_MACHINE = "x86_64-w64-mingw32"
    }
    default {
      throw "Unsupported address model: $env:QT_ADDRESS_MODEL"
    }
  }

  foreach ($qt_linkage in $qt_linkages) {
    $env:QT_LINKAGE = $qt_linkage
    $env:QT_BUILD_DIR = "$env:BUILD_DIR\icu-$env:QT_VERSION\$address_model\$env:QT_LINKAGE"
    $env:QT_HOME = "$env:QT_BUILD_DIR\icu"
    Write-Host "Assuming root folder for sources is: $env:QT_HOME"

    if (Test-Path -Path "$env:QT_HOME") {
      Write-Host "Found existing folder $env:QT_HOME, assuming that sources are in place and skipping downloading and unpacking of sources"
    } else {
      if ("$qt_downloaded" -ne "True") {
        if (Test-Path -Path "$qt_archive_file") {
          Write-Host "Found existing file $qt_archive_file, assuming that sources are downloaded and skipping downloading of sources"
        } else {
          # Download Qt
          Write-Host "Downloading Qt (source code archive) from: $qt_download_url into: $qt_archive_file"
          (New-Object System.Net.WebClient).DownloadFile("$qt_download_url", "$qt_archive_file")
        }
        $qt_downloaded = "True"
      }

      if (-not (Test-Path -Path "$env:QT_BUILD_DIR")) {
        New-Item -path "$env:QT_BUILD_DIR" -type directory | out-null
      }

      # Unpack Qt
      Write-Host "Extracting source code archive from $qt_archive_file to $env:QT_BUILD_DIR"
      & "$env:SEVEN_ZIP_HOME\7z.exe" x "$qt_archive_file" -o"$env:QT_BUILD_DIR" -aoa -y
      if ($LastExitCode -ne 0) {
        throw "Failed to extract Qt from $qt_archive_file to $env:QT_BUILD_DIR"
      }
      Write-Host "Extracted source code archive"
    }

    $env:QT_INSTALL_DIR = "$env:TARGET_DIR\icu-$env:QT_VERSION-$address_model_target_dir_suffix-mingw$mingw_version_suffix-$env:QT_LINKAGE"
    $env:QT_STAGE_DIR = "$env:QT_HOME\dist"
    $env:QT_STAGE_MSYS_DIR = "$env:QT_STAGE_DIR" -replace "\\", "/"
    $env:QT_STAGE_MSYS_DIR = "$env:QT_STAGE_MSYS_DIR" -replace "^(C):", "/c"

    Set-Location -Path "$env:QT_HOME\source"

    Write-Host "Building Qt with theses parameters:"
    Write-Host "MINGW_HOME                   : $env:MINGW_HOME"
    Write-Host "QT_HOME                      : $env:QT_HOME"
    Write-Host "QT_INSTALL_DIR               : $env:QT_INSTALL_DIR"
    Write-Host "QT_STAGE_DIR                 : $env:QT_STAGE_DIR"
    Write-Host "QT_STAGE_MSYS_DIR            : $env:QT_STAGE_MSYS_DIR"
    Write-Host "QT_BUILD_MACHINE             : $env:QT_BUILD_MACHINE"
    Write-Host "QT_ADDRESS_MODEL             : $env:QT_ADDRESS_MODEL"
    Write-Host "QT_LINKAGE                   : $env:QT_LINKAGE"
    Write-Host "QT_CONFIGURE_PATCH_FILE      : $env:QT_CONFIGURE_PATCH_FILE"
    Write-Host "QT_CONFIGURE_PATCH_MSYS_FILE : $env:QT_CONFIGURE_PATCH_MSYS_FILE"

    & "$env:SCRIPT_DIR\build.bat"
    if ($LastExitCode -ne 0) {
      throw "Failed to build Qt with QT_ADDRESS_MODEL = $env:QT_ADDRESS_MODEL, QT_LINKAGE = $env:QT_LINKAGE"
    }

    Write-Host "Copying built Qt from $env:QT_STAGE_DIR to $env:QT_INSTALL_DIR"
    Copy-Item -Force -Recurse -Path "$env:QT_STAGE_DIR" -Destination "$env:QT_INSTALL_DIR"
  }
}

Write-Host "Build completed successfully"
