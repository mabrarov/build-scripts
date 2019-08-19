#
# Copyright (c) 2019 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

# Find location of Visual Studio
$env:MSVS_INSTALL_DIR = &vswhere --% -latest -products Microsoft.VisualStudio.Product.Community -version [15.0,16.0) -requires Microsoft.VisualStudio.Workload.NativeDesktop -property installationPath
Write-Host "MSVS_INSTALL_DIR: ${env:MSVS_INSTALL_DIR}"

$env:MSVC_AUXILARY_DIR = "${env:MSVS_INSTALL_DIR}\VC\Auxiliary"
$env:MSVC_BUILD_DIR = "${env:MSVC_AUXILARY_DIR}\Build"

$qt_version_short = "${env:QT_VERSION}" -replace '(\d+)\.(\d+)\.(\d)', '$1.$2'
$qt_dist_base_name = "qt-everywhere-src-"
$qt_archive_file = "${env:DOWNLOAD_DIR}\${qt_dist_base_name}${env:QT_VERSION}.zip"
$qt_download_url = "${env:QT_URL}/${qt_version_short}/${env:QT_VERSION}/single/${qt_dist_base_name}${env:QT_VERSION}.zip"

$openssl_base_dir = "${env:DEPEND_DIR}"
if (Test-Path env:OPENSSL_DIR) {
  $openssl_base_dir = "${env:OPENSSL_DIR}"
}

# Build Qt
$address_models = @("64", "32")
$qt_linkages = @("shared", "static")

# Limit build configurations if user asked for that
if (Test-Path env:QT_ADDRESS_MODEL) {
  $address_models = @("${env:QT_ADDRESS_MODEL}")
}
if (Test-Path env:QT_LINKAGE) {
  $qt_linkages = @("${env:QT_LINKAGE}")
}

if (!(Test-Path env:QT_CONFIGURE_OPTIONS)) {
  $env:QT_CONFIGURE_OPTIONS = "-opengl desktop -icu"
  switch (${env:QT_VERSION}) {
    "5.13.0" {
      # todo
    }
    default {
      Write-Warning "Predfined QT_CONFIGURE_OPTIONS are missing because of unknown Qt version: ${env:QT_VERSION}"
    }
  }
}

# Extra build options for jom
$env:JOM_BUILD_OPTIONS = ""
if (Test-Path env:JOM_OPTIONS) {
  $env:JOM_BUILD_OPTIONS = " ${env:JOM_OPTIONS}"
}

$compiler_target_dir_suffix = "vs2017"
$qt_downloaded = $false

foreach ($address_model in ${address_models}) {
  $env:QT_ADDRESS_MODEL = ${address_model}

  # Determine parameters dependent on address model
  switch (${env:QT_ADDRESS_MODEL}) {
    "32" {
      $env:MSVC_CMD_BOOTSTRAP = "vcvars32.bat"
      $address_model_target_dir_suffix = "amd64_x86"
    }
    "64" {
      $env:MSVC_CMD_BOOTSTRAP = "vcvars64.bat"
      $address_model_target_dir_suffix = "x64"
    }
    default {
      throw "Unsupported address model: ${env:QT_ADDRESS_MODEL}"
    }
  }

  foreach ($qt_linkage in ${qt_linkages}) {
    $env:QT_LINKAGE = ${qt_linkage}
    $env:QT_BUILD_DIR = "${env:BUILD_DIR}\qt-${env:QT_VERSION}\${address_model}\${env:QT_LINKAGE}"
    $env:QT_HOME = "${env:QT_BUILD_DIR}\${qt_dist_base_name}${env:QT_VERSION}"
    Write-Host "Assuming root folder for sources is: ${env:QT_HOME}"

    $env:QT_CONFIGURE_OPTIONS_LINKAGE = ""
    switch (${env:QT_LINKAGE}) {
      "static" {
        $env:QT_CONFIGURE_OPTIONS_LINKAGE = "-static"
      }
      "shared" {
        $env:QT_CONFIGURE_OPTIONS_LINKAGE = ""
      }
      default {
        throw "Unsupported linkage: $env:QT_LINKAGE"
      }
    }

    if (Test-Path -Path "${env:QT_HOME}") {
      Write-Host "Found existing folder ${env:QT_HOME}, assuming that sources are in place and skipping downloading and unpacking of sources"
    } else {
      if (-not ${qt_downloaded}) {
        if (Test-Path -Path "${qt_archive_file}") {
          Write-Host "Found existing file ${qt_archive_file}, assuming that sources are downloaded and skipping downloading of sources"
        } else {
          # Download Qt
          Write-Host "Downloading Qt (source code archive) from: ${qt_download_url} into: ${qt_archive_file}"
          (New-Object System.Net.WebClient).DownloadFile("${qt_download_url}", "${qt_archive_file}")
        }
        $qt_downloaded = $true
      }

      if (-not (Test-Path -Path "${env:QT_BUILD_DIR}")) {
        New-Item -path "${env:QT_BUILD_DIR}" -type directory | out-null
      }

      # Unpack Qt
      Write-Host "Extracting source code archive from ${qt_archive_file} to ${env:QT_BUILD_DIR}"
      & "${env:SEVEN_ZIP_HOME}\7z.exe" x "${qt_archive_file}" -o"${env:QT_BUILD_DIR}" -aoa -y -bd | out-null
      if (${LastExitCode} -ne 0) {
        throw "Failed to extract Qt from ${qt_archive_file} to ${env:QT_BUILD_DIR}"
      }
      Write-Host "Extracted source code archive"
    }

    $qt_install_dir_name = "qt-${env:QT_VERSION}-${address_model_target_dir_suffix}-${compiler_target_dir_suffix}-${env:QT_LINKAGE}"
    $env:QT_INSTALL_DIR = "${env:BUILD_DIR}\${qt_install_dir_name}"
    $env:QT_DEPLOY_DIR = "${env:TARGET_DIR}\${qt_install_dir_name}"

    # Prepare patch for Qt
    $env:QT_PATCH_FILE = ""
    if (Test-Path env:QT_PATCH) {
      $env:QT_PATCH_FILE = "${env:QT_PATCH}"
    } else {
      $env:QT_PATCH_FILE = "${env:SCRIPT_DIR}\patches\qt-${env:QT_VERSION}-${env:QT_LINKAGE}.patch"
    }
    if ("${env:QT_PATCH_FILE}" -ne "" -and -not (Test-Path -Path "${env:QT_PATCH_FILE}")) {
      Write-Warning "Patch for chosen version of Qt (${env:QT_VERSION}) and linkage (${env:QT_LINKAGE}) was not found at ${env:QT_PATCH_FILE}"
      $env:QT_PATCH_FILE = ""
    }
    $env:QT_PATCH_MSYS_FILE = "${env:QT_PATCH_FILE}" -replace "\\", "/"
    $env:QT_PATCH_MSYS_FILE = "${env:QT_PATCH_MSYS_FILE}" -replace "^(C):", "/c"

    $env:OPENSSL_DIR = "${openssl_base_dir}\openssl-${env:OPENSSL_VERSION}-${address_model_target_dir_suffix}-${compiler_target_dir_suffix}-${env:QT_LINKAGE}"
    if (-not (Test-Path -Path "${env:OPENSSL_DIR}")) {
      Write-Error "OpenSSL not found at ${env:OPENSSL_DIR}"
    }

    $env:ICU_DIR = "${openssl_base_dir}\icu4c-${env:ICU_VERSION}-${address_model_target_dir_suffix}-${compiler_target_dir_suffix}-${env:QT_LINKAGE}"
    if (-not (Test-Path -Path "${env:ICU_DIR}")) {
      Write-Error "ICU not found at ${env:ICU_DIR}"
    }

    Set-Location -Path "${env:QT_HOME}"

    Write-Host "Building Qt with these parameters:"
    Write-Host "MSVC_BUILD_DIR               : ${env:MSVC_BUILD_DIR}"
    Write-Host "MSVC_CMD_BOOTSTRAP           : ${env:MSVC_CMD_BOOTSTRAP}"
    Write-Host "OPENSSL_DIR                  : ${env:OPENSSL_DIR}"
    Write-Host "ICU_DIR                      : ${env:ICU_DIR}"
    Write-Host "QT_HOME                      : ${env:QT_HOME}"
    Write-Host "QT_INSTALL_DIR               : ${env:QT_INSTALL_DIR}"
    Write-Host "QT_ADDRESS_MODEL             : ${env:QT_ADDRESS_MODEL}"
    Write-Host "QT_LINKAGE                   : ${env:QT_LINKAGE}"
    Write-Host "QT_CONFIGURE_OPTIONS_LINKAGE : ${env:QT_CONFIGURE_OPTIONS_LINKAGE}"
    Write-Host "QT_CONFIGURE_OPTIONS         : ${env:QT_CONFIGURE_OPTIONS}"
    Write-Host "QT_PATCH_FILE                : ${env:QT_PATCH_FILE}"
    Write-Host "QT_PATCH_MSYS_FILE           : ${env:QT_PATCH_MSYS_FILE}"
    Write-Host "QT_DEPLOY_DIR                : ${env:QT_DEPLOY_DIR}"

    & "${env:SCRIPT_DIR}\build.bat"
    if (${LastExitCode} -ne 0) {
      throw "Failed to build Qt with QT_ADDRESS_MODEL = ${env:QT_ADDRESS_MODEL}, QT_LINKAGE = ${env:QT_LINKAGE}"
    }
    Write-Host "Copying built Qt from ${env:QT_INSTALL_DIR} to ${env:QT_DEPLOY_DIR}"
    Copy-Item -Force -Recurse -Path "${env:QT_INSTALL_DIR}" -Destination "${env:QT_DEPLOY_DIR}"
  }
}

Write-Host "Build completed successfully"
