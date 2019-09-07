#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

# Enable all versions of TLS
[System.Net.ServicePointManager]::SecurityProtocol = @("Tls12","Tls11","Tls","Ssl3")

# Required for unpacking with tar
$env:PATH = "${env:MSYS_HOME}\usr\bin;${env:PATH}"

$openssl_archive_file = "${env:DOWNLOAD_DIR}\openssl-${env:OPENSSL_VERSION}.tar.gz"
$openssl_download_url = "${env:OPENSSL_URL}/openssl-${env:OPENSSL_VERSION}.tar.gz"

# Prepare patch for OpenSSL
if (-not (Test-Path env:OPENSSL_PATCH_FILE)) {
  $env:OPENSSL_PATCH_FILE = "${PSScriptRoot}\patches\openssl-${env:OPENSSL_VERSION}.patch"
}
if (-not (Test-Path -Path "${env:OPENSSL_PATCH_FILE}")) {
  Write-Warning "Patch for chosen version of OpenSSL (${env:OPENSSL_VERSION}) was not found at ${env:OPENSSL_PATCH_FILE}"
  $env:OPENSSL_PATCH_FILE = ""
}
$env:OPENSSL_PATCH_MSYS_FILE = "${env:OPENSSL_PATCH_FILE}" -replace "\\", "/"
$env:OPENSSL_PATCH_MSYS_FILE = "${env:OPENSSL_PATCH_MSYS_FILE}" -replace "^(C):", "/c"

# Build OpenSSL
$address_models = @("64", "32")
$openssl_linkages = @("shared", "static")

# Limit build configurations if user asked for that
if (Test-Path env:OPENSSL_ADDRESS_MODEL) {
  $address_models = @("${env:OPENSSL_ADDRESS_MODEL}")
}
if (Test-Path env:OPENSSL_LINKAGE) {
  $openssl_linkages = @("${env:OPENSSL_LINKAGE}")
}

$openssl_downloaded = $false

foreach ($address_model in ${address_models}) {
  $env:OPENSSL_ADDRESS_MODEL = ${address_model}

  # Determine parameters dependent on address model
  switch (${env:OPENSSL_ADDRESS_MODEL}) {
    "32" {
      $env:MINGW_HOME = "${env:MINGW32_HOME}"
      $env:OPENSSL_TOOLSET = "mingw"
      $address_model_target_dir_suffix = "x86"
    }
    "64" {
      $env:MINGW_HOME = "${env:MINGW64_HOME}"
      $env:OPENSSL_TOOLSET = "mingw64"
      $address_model_target_dir_suffix = "x64"
    }
    default {
      throw "Unsupported address model: ${env:OPENSSL_ADDRESS_MODEL}"
    }
  }

  $mingw_version_suffix = "${env:MINGW_VERSION}" -replace "([0-9]+)\.([0-9]+)\.([0-9]+)", '$1$2'

  foreach ($openssl_linkage in ${openssl_linkages}) {
    $env:OPENSSL_LINKAGE = ${openssl_linkage}

    # Determine parameters dependent on linkage
    switch (${env:OPENSSL_LINKAGE}) {
      "shared" {
        $env:OPENSSL_CONFIGURE_LINKAGE = "shared"
      }
      "static" {
        $env:OPENSSL_CONFIGURE_LINKAGE = "no-shared"
      }
      default {
        throw "Unsupported linkage: ${env:OPENSSL_LINKAGE}"
      }
    }

    $env:OPENSSL_BUILD_DIR = "${env:BUILD_DIR}\openssl-${env:OPENSSL_VERSION}\${address_model}\${env:OPENSSL_LINKAGE}"
    $env:OPENSSL_HOME = "${env:OPENSSL_BUILD_DIR}\openssl-${env:OPENSSL_VERSION}"
    Write-Host "Assuming root folder for sources is: ${env:OPENSSL_HOME}"

    if (Test-Path -Path "${env:OPENSSL_HOME}") {
      Write-Host "Found existing folder ${env:OPENSSL_HOME}, assuming that sources are in place and skipping downloading and unpacking of sources"
    } else {
      if (-not ${openssl_downloaded}) {
        if (Test-Path -Path "${openssl_archive_file}") {
          Write-Host "Found existing file ${openssl_archive_file}, assuming that sources are downloaded and skipping downloading of sources"
        } else {
          # Download OpenSSL
          Write-Host "Downloading OpenSSL (source code archive) from: ${openssl_download_url} into: ${openssl_archive_file}"
          (New-Object System.Net.WebClient).DownloadFile("${openssl_download_url}", "${openssl_archive_file}")
        }
        $openssl_downloaded = $true
      }

      if (-not (Test-Path -Path "${env:OPENSSL_BUILD_DIR}")) {
        New-Item -Path "${env:OPENSSL_BUILD_DIR}" -ItemType "directory" | out-null
      }

      # Unpack OpenSSL
      Write-Host "Extracting source code archive from ${openssl_archive_file} to ${env:OPENSSL_BUILD_DIR}"
      Set-Location -Path "${env:OPENSSL_BUILD_DIR}"
      $openssl_archive_msys_file = "${openssl_archive_file}" -replace "\\", "/"
      $openssl_archive_msys_file = "${openssl_archive_msys_file}" -replace "^(C):", "/c"
      & tar.exe xzf "${openssl_archive_msys_file}"
      if (${LastExitCode} -ne 0) {
        throw "Failed to extract OpenSSL from ${openssl_archive_file} to ${env:OPENSSL_BUILD_DIR}"
      }
      Write-Host "Extracted source code archive"
    }

    $env:OPENSSL_INSTALL_DIR = "${env:TARGET_DIR}\openssl-${env:OPENSSL_VERSION}-${address_model_target_dir_suffix}-mingw${mingw_version_suffix}-${env:OPENSSL_LINKAGE}"
    $env:OPENSSL_STAGE_DIR = "${env:OPENSSL_HOME}\dist"
    $env:OPENSSL_STAGE_MSYS_DIR = "${env:OPENSSL_STAGE_DIR}" -replace "\\", "/"
    $env:OPENSSL_STAGE_MSYS_DIR = "${env:OPENSSL_STAGE_MSYS_DIR}" -replace "^(C):", "/c"

    Set-Location -Path "${env:OPENSSL_HOME}"

    Write-Host "Building OpenSSL with these parameters:"
    Write-Host "MINGW_HOME                : ${env:MINGW_HOME}"
    Write-Host "MSYS_HOME                 : ${env:MSYS_HOME}"
    Write-Host "OPENSSL_HOME              : ${env:OPENSSL_HOME}"
    Write-Host "OPENSSL_INSTALL_DIR       : ${env:OPENSSL_INSTALL_DIR}"
    Write-Host "OPENSSL_STAGE_DIR         : ${env:OPENSSL_STAGE_DIR}"
    Write-Host "OPENSSL_STAGE_MSYS_DIR    : ${env:OPENSSL_STAGE_MSYS_DIR}"
    Write-Host "OPENSSL_TOOLSET           : ${env:OPENSSL_TOOLSET}"
    Write-Host "OPENSSL_ADDRESS_MODEL     : ${env:OPENSSL_ADDRESS_MODEL}"
    Write-Host "OPENSSL_LINKAGE           : ${env:OPENSSL_LINKAGE}"
    Write-Host "OPENSSL_CONFIGURE_LINKAGE : ${env:OPENSSL_CONFIGURE_LINKAGE}"
    Write-Host "OPENSSL_PATCH_FILE        : ${env:OPENSSL_PATCH_FILE}"
    Write-Host "OPENSSL_PATCH_MSYS_FILE   : ${env:OPENSSL_PATCH_MSYS_FILE}"

    & "${PSScriptRoot}\build.bat"
    if (${LastExitCode} -ne 0) {
      throw "Failed to build OpenSSL with OPENSSL_ADDRESS_MODEL = ${env:OPENSSL_ADDRESS_MODEL}, OPENSSL_LINKAGE = ${env:OPENSSL_LINKAGE}"
    }

    Write-Host "Copying built OpenSSL from ${env:OPENSSL_STAGE_DIR} to ${env:OPENSSL_INSTALL_DIR}"
    Copy-Item -Force -Recurse -Path "${env:OPENSSL_STAGE_DIR}" -Destination "${env:OPENSSL_INSTALL_DIR}"
  }
}

Write-Host "Build completed successfully"
