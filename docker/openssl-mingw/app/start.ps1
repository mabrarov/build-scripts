#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the Boost Software License, Version 1.0. (See accompanying
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

# Location of MinGW
$env:MINGW64_HOME = "$env:ProgramFiles\mingw64"
$env:MINGW32_HOME = "${env:ProgramFiles(x86)}\mingw32"

# Location of ActivePerl
$env:PERL_HOME = "C:\Perl64"

$openssl_archive_file = "$env:DOWNLOAD_DIR\openssl-$env:OPENSSL_VERSION.tar.gz"
$openssl_tar_archive_file = "openssl-$env:OPENSSL_VERSION.tar"
$openssl_download_url = "$env:OPENSSL_URL/openssl-$env:OPENSSL_VERSION.tar.gz"

# Build OpenSSL
$address_models = @("64", "32")
$openssl_linkages = @("shared", "static")
$runtime_linkages = @("shared", "static")

# Limit build configurations if user asked for that
if (Test-Path env:OPENSSL_ADDRESS_MODEL) {
  $address_models = @("$env:OPENSSL_ADDRESS_MODEL")
}
if (Test-Path env:OPENSSL_LINKAGE) {
  $openssl_linkages = @("$env:OPENSSL_LINKAGE")
}
if (Test-Path env:OPENSSL_RUNTIME_LINKAGE) {
  $runtime_linkages = @("$env:OPENSSL_RUNTIME_LINKAGE")
}

$openssl_downloaded = "False"

foreach ($address_model in $address_models) {
  $env:OPENSSL_ADDRESS_MODEL = $address_model

  # Determine parameters dependent on address model
  switch ($env:OPENSSL_ADDRESS_MODEL) {
    "32" {
      $env:MINGW_HOME = "$env:MINGW32_HOME"
      $env:OPENSSL_TOOLSET = "mingw"
      $address_model_target_dir_suffix = "x86"
    }
    "64" {
      $env:MINGW_HOME = "$env:MINGW64_HOME"
      $env:OPENSSL_TOOLSET = "mingw64"
      $address_model_target_dir_suffix = "x64"
    }
    default {
      throw "Unsupported address model: $env:OPENSSL_ADDRESS_MODEL"
    }
  }

  $mingw_version_suffix = "$env:MINGW_VERSION" -replace "\.", ''

  foreach ($openssl_linkage in $openssl_linkages) {
    $env:OPENSSL_LINKAGE = $openssl_linkage
    foreach ($runtime_linkage in $runtime_linkages) {
      if ($runtime_linkage -eq "static" -and -not ($openssl_linkage -eq "static")) {
        # Nothing to do with this type of configuration - just skip it
        continue
      }
      if ($openssl_linkage -eq "static" -and -not ($runtime_linkage -eq "static")) {
        # Nothing to do with this type of configuration - just skip it
        continue
      }
      $env:OPENSSL_RUNTIME_LINKAGE = $runtime_linkage

      $env:OPENSSL_BUILD_DIR="$env:BUILD_DIR\openssl-$env:OPENSSL_VERSION\$address_model\$env:OPENSSL_LINKAGE"
      $env:OPENSSL_HOME="$env:OPENSSL_BUILD_DIR\openssl-$env:OPENSSL_VERSION"
      Write-Host "Assuming root folder for sources is: $env:OPENSSL_HOME"

      if (Test-Path -Path "$env:OPENSSL_HOME") {
        Write-Host "Found existing folder $env:OPENSSL_HOME, assuming that sources are in place and skipping downloading and unpacking of sources"
      } else {
        if ("$openssl_downloaded" -ne "True") {
          if (Test-Path -Path "$openssl_archive_file") {
            Write-Host "Found existing file $openssl_archive_file, assuming that sources are downloaded and skipping downloading of sources"
          } else {
            # Download OpenSSL
            Write-Host "Downloading OpenSSL (source code archive) from: $openssl_download_url into: $openssl_archive_file"
            Invoke-WebRequest -Uri "$openssl_download_url" -OutFile "$openssl_archive_file"
          }
          $openssl_downloaded = "True"
        }

        if (-not (Test-Path -Path "$env:OPENSSL_BUILD_DIR")) {
          New-Item -path "$env:OPENSSL_BUILD_DIR" -type directory | out-null
        }

        # Unpack OpenSSL
        $openssl_tar_archive_file_path = "$env:TMP\$openssl_tar_archive_file"
        if (-not (Test-Path -Path "$openssl_tar_archive_file_path")) {
          Write-Host "Extracting source code archive from $openssl_archive_file to $env:TMP"
          & "$env:ProgramFiles\7-Zip\7z.exe" x "$openssl_archive_file" -o"$env:TMP" -aoa -y | out-null
          if ($LastExitCode -ne 0) {
            throw "Failed to extract OpenSSL from $openssl_archive_file to $env:TMP"
          }
        }
        Write-Host "Extracting source code archive from $openssl_tar_archive_file_path to $env:OPENSSL_BUILD_DIR"
        & "$env:ProgramFiles\7-Zip\7z.exe" x "$openssl_tar_archive_file_path" -o"$env:OPENSSL_BUILD_DIR" -aoa -y | out-null
        if ($LastExitCode -ne 0) {
          throw "Failed to extract OpenSSL from $openssl_archive_file to $env:OPENSSL_BUILD_DIR"
        }
        Write-Host "Extracted source code archive"
      }

      $env:OPENSSL_INSTALL_DIR = "$env:TARGET_DIR\openssl-$env:OPENSSL_VERSION-$address_model_target_dir_suffix-mingw$mingw_version_suffix-$env:OPENSSL_LINKAGE"

      Set-Location -Path "$env:OPENSSL_HOME"
      Write-Host "Building OpenSSL with theses parameters:"
      Write-Host "MINGW_HOME             : $env:MINGW_HOME"
      Write-Host "OPENSSL_INSTALL_DIR    : $env:OPENSSL_INSTALL_DIR"
      Write-Host "OPENSSL_TOOLSET        : $env:OPENSSL_TOOLSET"
      Write-Host "OPENSSL_ADDRESS_MODEL  : $env:OPENSSL_ADDRESS_MODEL"
      Write-Host "OPENSSL_LINKAGE        : $env:OPENSSL_LINKAGE"
      Write-Host "OPENSSL_RUNTIME_LINKAGE: $env:OPENSSL_RUNTIME_LINKAGE"
      & "$env:SCRIPT_DIR\build.bat"
      if ($LastExitCode -ne 0) {
          throw "Failed to build OpenSSL with OPENSSL_ADDRESS_MODEL = $env:OPENSSL_ADDRESS_MODEL, OPENSSL_LINKAGE = $env:OPENSSL_LINKAGE, OPENSSL_RUNTIME_LINKAGE = $env:OPENSSL_RUNTIME_LINKAGE"
      }
    }
  }
}

Write-Host "Build completed successfully"
