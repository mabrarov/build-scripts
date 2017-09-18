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

# Location of 7-Zip
$env:SEVEN_ZIP_HOME = "$env:ProgramFiles\7-Zip"

# Location of Active Perl
$env:PERL_HOME = "C:\Perl64"

# Location of Python
$python_version_short = $env:PYTHON_VERSION -replace '(\d+)\.(\d+)\.(\d)', '$1$2'
$env:PYTHON_HOME = "$env:ProgramFiles\Python$python_version_short"

# Location of MSYS2
$env:MSYS_HOME = "C:\msys64"

$qt_version_short = "$env:QT_VERSION" -replace '(\d+)\.(\d+)\.(\d)', '$1.$2'
$qt_archive_file = "$env:DOWNLOAD_DIR\qt-everywhere-opensource-src-$env:QT_VERSION.zip"
$qt_download_url = "$env:QT_URL/$qt_version_short/$env:QT_VERSION/single/qt-everywhere-opensource-src-$env:QT_VERSION.zip"

if (Test-Path env:ICU_DIR) {
  $env:ICU_DIR = "$env:DEPEND_DIR\icu"
}

if (Test-Path env:OPENSSL_DIR) {
  $env:OPENSSL_DIR = "$env:DEPEND_DIR\openssl"
}

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
    }
    "64" {
      $env:MINGW_HOME = "$env:MINGW64_HOME"
      $address_model_target_dir_suffix = "x64"
    }
    default {
      throw "Unsupported address model: $env:QT_ADDRESS_MODEL"
    }
  }

  foreach ($qt_linkage in $qt_linkages) {
    $env:QT_LINKAGE = $qt_linkage
    $env:QT_BUILD_DIR = "$env:BUILD_DIR\qt-$env:QT_VERSION\$address_model\$env:QT_LINKAGE"
    $env:QT_HOME = "$env:QT_BUILD_DIR\qt-everywhere-opensource-src-$env:QT_VERSION"
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

    $env:QT_INSTALL_DIR = "$env:TARGET_DIR\qt-$env:QT_VERSION-$address_model_target_dir_suffix-mingw$mingw_version_suffix-$env:QT_LINKAGE"

    # Prepare patch for Qt
    if (Test-Path env:QT_PATCH) {
      $env:QT_PATCH_FILE = "$env:QT_PATCH"
    } else {
      switch ($env:QT_LINKAGE) {
        "static" {
          $env:QT_PATCH_FILE = "$env:SCRIPT_DIR\qt-$env:QT_VERSION-patches\static.patch"
        }
        "shared" {
          $env:QT_PATCH_FILE = ""
        }
        default {
          throw "Unsupported linkage: $env:QT_LINKAGE"
        }
      }
    }
    if ("$env:QT_PATCH_FILE" -ne "" -and -not (Test-Path -Path "$env:QT_PATCH_FILE")) {
      Write-Warning "Patch for chosen version of Qt ($env:QT_VERSION) was not found at $env:QT_PATCH_FILE"
      $env:QT_PATCH_FILE = ""
    }
    $env:QT_PATCH_MSYS_FILE = "$env:QT_PATCH_FILE" -replace "\\", "/"
    $env:QT_PATCH_MSYS_FILE = "$env:QT_PATCH_MSYS_FILE" -replace "^(C):", "/c"

    Set-Location -Path "$env:QT_HOME"

    Write-Host "Building Qt with theses parameters:"
    Write-Host "MINGW_HOME         : $env:MINGW_HOME"
    Write-Host "QT_HOME            : $env:QT_HOME"
    Write-Host "QT_INSTALL_DIR     : $env:QT_INSTALL_DIR"
    Write-Host "QT_ADDRESS_MODEL   : $env:QT_ADDRESS_MODEL"
    Write-Host "QT_LINKAGE         : $env:QT_LINKAGE"
    Write-Host "QT_PATCH_FILE      : $env:QT_PATCH_FILE"
    Write-Host "QT_PATCH_MSYS_FILE : $env:QT_PATCH_MSYS_FILE"

    # todo ICU_DIR
    # todo OPENSSL_DIR

    & "$env:SCRIPT_DIR\build.bat"
    if ($LastExitCode -ne 0) {
      throw "Failed to build Qt with QT_ADDRESS_MODEL = $env:QT_ADDRESS_MODEL, QT_LINKAGE = $env:QT_LINKAGE"
    }
  }
}

Write-Host "Build completed successfully"
