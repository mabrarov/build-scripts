#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

# Enable all versions of TLS
[System.Net.ServicePointManager]::SecurityProtocol = @("Tls12","Tls11","Tls","Ssl3")

$env:OPENSSL_HOME = "${env:BUILD_DIR}\openssl-${env:OPENSSL_VERSION}"
if (Test-Path -Path "${env:OPENSSL_HOME}") {
  Write-Host "Found existing folder ${env:OPENSSL_HOME}, assuming that sources are in place and skipping downloading and unpacking of sources"
} else {
  $openssl_archive_file = "${env:DOWNLOAD_DIR}\openssl-${env:OPENSSL_VERSION}.tar.gz"
  if (Test-Path -Path "${openssl_archive_file}") {
    Write-Host "Found existing file ${openssl_archive_file}, assuming that sources are downloaded and skipping downloading of sources"
  } else {
    # Download OpenSSL
    $openssl_download_url = "${env:OPENSSL_URL}/openssl-${env:OPENSSL_VERSION}/openssl-${env:OPENSSL_VERSION}.tar.gz"
    Write-Host "Downloading OpenSSL (source code archive) from: ${openssl_download_url} into: ${openssl_archive_file}"
    (New-Object System.Net.WebClient).DownloadFile("${openssl_download_url}", "${openssl_archive_file}")
  }
  # Unpack OpenSSL
  Write-Host "Extracting source code archive from ${openssl_archive_file} to ${env:BUILD_DIR}"
  $openssl_archive_msys_file = "${openssl_archive_file}" -replace "\\", "/"
  $openssl_archive_msys_file = "${openssl_archive_msys_file}" -replace "^(C):", "/c"
  $build_dir_msys = "${env:BUILD_DIR}" -replace "\\", "/"
  $build_dir_msys = "${build_dir_msys}" -replace "^(C):", "/c"
  # Path is required to be changed for Gnu tar shipped with MSYS2
  $path_backup = "${env:PATH}"
  $env:PATH = "${env:MSYS_HOME}\usr\bin;${env:PATH}"
  & tar.exe xzf "${openssl_archive_msys_file}" -C "${build_dir_msys}"
  $tar_exit_code = ${LastExitCode}
  $env:PATH = "${path_backup}"
  if (${tar_exit_code} -ne 0) {
    throw "Failed to extract OpenSSL from ${openssl_archive_file} to ${env:OPENSSL_BUILD_DIR}"
  }
  Write-Host "Extracted source code archive"
}

# Patch OpenSSL
if (-not (Test-Path env:OPENSSL_PATCH_FILE)) {
  $env:OPENSSL_PATCH_FILE = "${PSScriptRoot}\patches\openssl-${env:OPENSSL_VERSION}.patch"
}
if (-not (Test-Path -Path "${env:OPENSSL_PATCH_FILE}")) {
  Write-Warning "Patch for chosen version of OpenSSL (${env:OPENSSL_VERSION}) was not found at ${env:OPENSSL_PATCH_FILE}"
} else {
  Write-Host "Patching OpenSSL located at ${env:OPENSSL_HOME} with ${env:OPENSSL_PATCH_FILE}"
  Set-Location -Path "${env:OPENSSL_HOME}"
  $path_backup = "${env:PATH}"
  $env:PATH = "${env:MSYS_HOME}\usr\bin;${env:PATH}"
  & patch.exe -uNf -p0 -i "${env:OPENSSL_PATCH_FILE}"
  $patch_exit_code = ${LastExitCode}
  $env:PATH = "${path_backup}"
  if (${patch_exit_code} -ne 0) {
    throw "Failed to patch OpenSSL located at ${env:OPENSSL_HOME} with ${env:OPENSSL_PATCH_FILE}"
  }
}

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

$mingw_version_suffix = "${env:MINGW_VERSION}" -replace "([0-9]+)\.([0-9]+)\.([0-9]+)", '$1$2'

foreach ($address_model in ${address_models}) {
  $env:OPENSSL_ADDRESS_MODEL = ${address_model}

  # Determine parameters dependent on address model
  switch (${env:OPENSSL_ADDRESS_MODEL}) {
    "32" {
      $env:MINGW_HOME = "${env:MINGW32_HOME}"
      $env:OPENSSL_TOOLSET = "mingw"
      $address_model_target_dir_suffix = "x86"
      $env:NASM_HOME = "${env:NASM32_HOME}"
    }
    "64" {
      $env:MINGW_HOME = "${env:MINGW64_HOME}"
      $env:OPENSSL_TOOLSET = "mingw64"
      $address_model_target_dir_suffix = "x64"
      $env:NASM_HOME = "${env:NASM64_HOME}"
    }
    default {
      throw "Unsupported address model: ${env:OPENSSL_ADDRESS_MODEL}"
    }
  }

  foreach ($openssl_linkage in ${openssl_linkages}) {
    $env:OPENSSL_LINKAGE = ${openssl_linkage}

    # Determine parameters dependent on linkage
    switch (${env:OPENSSL_LINKAGE}) {
      "shared" {
        $env:OPENSSL_LINKAGE_CONFIG = "shared"
      }
      "static" {
        $env:OPENSSL_LINKAGE_CONFIG = "no-shared"
      }
      default {
        throw "Unsupported linkage: ${env:OPENSSL_LINKAGE}"
      }
    }

    $env:OPENSSL_BUILD_TYPE = "release"

    if (${env:OPENSSL_BUILD_TYPE} -eq "debug") {
      $env:OPENSSL_BUILD_TYPE_CONFIG = "--debug"
    } else {
      $env:OPENSSL_BUILD_TYPE_CONFIG = "--release"
    }

    $env:OPENSSL_BUILD_DIR = "${env:TMP}\openssl-${env:OPENSSL_VERSION}\build\${address_model}\${env:OPENSSL_LINKAGE}"
    $env:OPENSSL_INSTALL_DIR = "${env:TMP}\openssl-${env:OPENSSL_VERSION}\install\${address_model}\${env:OPENSSL_LINKAGE}"
    $env:OPENSSL_TARGET_DIR = "${env:TARGET_DIR}\openssl-${env:OPENSSL_VERSION}-${address_model_target_dir_suffix}-mingw${mingw_version_suffix}-${env:OPENSSL_LINKAGE}"

    New-Item -Path "${env:OPENSSL_BUILD_DIR}" -ItemType "directory" | out-null
    New-Item -Path "${env:OPENSSL_INSTALL_DIR}" -ItemType "directory" | out-null

    Write-Host "Building OpenSSL with these parameters:"
    Write-Host "MINGW_HOME            : ${env:MINGW_HOME}"
    Write-Host "NASM_HOME             : ${env:NASM_HOME}"
    Write-Host "MSYS_HOME             : ${env:MSYS_HOME}"
    Write-Host "OPENSSL_HOME          : ${env:OPENSSL_HOME}"
    Write-Host "OPENSSL_TARGET_DIR    : ${env:OPENSSL_TARGET_DIR}"
    Write-Host "OPENSSL_INSTALL_DIR   : ${env:OPENSSL_INSTALL_DIR}"
    Write-Host "OPENSSL_BUILD_DIR     : ${env:OPENSSL_BUILD_DIR}"
    Write-Host "OPENSSL_ADDRESS_MODEL : ${env:OPENSSL_ADDRESS_MODEL}"
    Write-Host "OPENSSL_LINKAGE       : ${env:OPENSSL_LINKAGE}"
    Write-Host "OPENSSL_BUILD_TYPE    : ${env:OPENSSL_BUILD_TYPE}"
    Write-Host "OPENSSL_TOOLSET       : ${env:OPENSSL_TOOLSET}"

    & "${PSScriptRoot}\build.bat"
    if (${LastExitCode} -ne 0) {
      throw "Failed to build OpenSSL with OPENSSL_ADDRESS_MODEL = ${env:OPENSSL_ADDRESS_MODEL}, OPENSSL_LINKAGE = ${env:OPENSSL_LINKAGE}, OPENSSL_BUILD_TYPE = ${env:OPENSSL_BUILD_TYPE}"
    }

    Write-Host "Copying built OpenSSL from ${env:OPENSSL_INSTALL_DIR} to ${env:OPENSSL_TARGET_DIR}"
    Copy-Item -Force -Recurse -Path "${env:OPENSSL_INSTALL_DIR}" -Destination "${env:OPENSSL_TARGET_DIR}"

    Remove-Item -Path "${env:OPENSSL_BUILD_DIR}" -Recurse -Force
    Remove-Item -Path "${env:OPENSSL_INSTALL_DIR}" -Recurse -Force
  }
}

Write-Host "Build completed successfully"
