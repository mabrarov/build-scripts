#
# Copyright (c) 2019 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

# Enable all versions of TLS
[System.Net.ServicePointManager]::SecurityProtocol = @("Tls12","Tls11","Tls","Ssl3")

# Find location of Visual Studio
$env:MSVS_INSTALL_DIR = &vswhere --% -latest -products Microsoft.VisualStudio.Product.Community -version [16.0,17.0) -requires Microsoft.VisualStudio.Workload.NativeDesktop -property installationPath
$env:MSVC_AUXILARY_DIR = "${env:MSVS_INSTALL_DIR}\VC\Auxiliary"
$env:MSVC_BUILD_DIR = "${env:MSVC_AUXILARY_DIR}\Build"

$boost_version_underscore = "${env:BOOST_VERSION}" -replace "\.", '_'
$env:BOOST_ROOT_DIR = "${env:BUILD_DIR}\boost_${boost_version_underscore}"
Write-Host "Assuming root folder for sources is: ${env:BOOST_ROOT_DIR}"

if (Test-Path -Path "${env:BOOST_ROOT_DIR}") {
  Write-Host "Found existing folder ${env:BOOST_ROOT_DIR}, assuming that sources are in place and skipping downloading and unpacking of sources"
} else {
  # Boost sources were not mounted or were not deployed yet
  $boost_archive_file = "${env:DOWNLOAD_DIR}\boost_${boost_version_underscore}.zip"
  if (Test-Path -Path "${boost_archive_file}") {
    Write-Host "Found existing file ${boost_archive_file}, assuming that sources are downloaded and skipping downloading of sources"
  } else {
    # Download Boost C++ Libraries
    $boost_download_url = "${env:BOOST_RELEASE_URL}/${env:BOOST_VERSION}/source/boost_${boost_version_underscore}.zip"
    Write-Host "Downloading Boost C++ Libraries (source code archive) from: ${boost_download_url} into: ${boost_archive_file}"
    (New-Object System.Net.WebClient).DownloadFile("${boost_download_url}", "${boost_archive_file}")
  }
  # Unpack Boost C++ Libraries
  Write-Host "Extracting source code archive to: ${env:BUILD_DIR}"
  & "${env:SEVEN_ZIP_HOME}\7z.exe" x "${boost_archive_file}" -o"${env:BUILD_DIR}" -aoa -y -bd | out-null
  if (${LastExitCode} -ne 0) {
    throw "Failed to extract Boost from ${boost_archive_file} to ${env:BUILD_DIR}"
  }
  Write-Host "Extracted source code archive"
}

$env:B2_BIN = "${env:BOOST_ROOT_DIR}\b2.exe"
$env:B2_TOOLSET = "msvc-14.2"

# Build Boost.Build
$env:MSVC_CMD_BOOTSTRAP = "vcvars64.bat"
$env:BOOST_BOOTSTRAP = "${env:BOOST_ROOT_DIR}\bootstrap.bat"
Set-Location -Path "${env:BOOST_ROOT_DIR}"
Write-Host "Building Boost.Build engine"
& "${PSScriptRoot}\bootstrap.bat"
if (${LastExitCode} -ne 0) {
  throw "Failed to build Boost.Build"
}

# Build Boost C++ Libraries
$address_models = @("64", "32")
$boost_linkages = @("shared", "static")
$runtime_linkages = @("shared", "static")

# Limit build configurations if user asked for that
if (Test-Path env:BOOST_ADDRESS_MODEL) {
  $address_models = @("${env:BOOST_ADDRESS_MODEL}")
}
if (Test-Path env:BOOST_LINKAGE) {
  $boost_linkages = @("${env:BOOST_LINKAGE}")
}
if (Test-Path env:BOOST_RUNTIME_LINKAGE) {
  $runtime_linkages = @("${env:BOOST_RUNTIME_LINKAGE}")
}

if (!(Test-Path env:B2_OPTIONS)) {
  $env:B2_OPTIONS = ""
}

foreach ($address_model in ${address_models}) {
  $env:BOOST_ADDRESS_MODEL = ${address_model}

  # Determine parameters dependent on address model
  switch (${env:BOOST_ADDRESS_MODEL}) {
    "32" {
      $env:MSVC_CMD_BOOTSTRAP = "vcvars32.bat"
      $target_dir_suffix = "x86"
    }
    "64" {
      $env:MSVC_CMD_BOOTSTRAP = "vcvars64.bat"
      $target_dir_suffix = "x64"
    }
    default {
      throw "Unsupported address model: ${env:BOOST_ADDRESS_MODEL}"
    }
  }

  $env:BOOST_INSTALL_DIR = "${env:TARGET_DIR}\boost-${env:BOOST_VERSION}-${target_dir_suffix}-vs2019"
  foreach ($boost_linkage in ${boost_linkages}) {
    $env:BOOST_LINKAGE = ${boost_linkage}
    foreach ($runtime_linkage in ${runtime_linkages}) {
      if (${runtime_linkage} -eq "static" -and -not (${boost_linkage} -eq "static")) {
        # Nothing to do with this type of configuration - just skip it
        continue
      }
      $env:BOOST_RUNTIME_LINKAGE = ${runtime_linkage}
      Set-Location -Path "${env:BOOST_ROOT_DIR}"
      Write-Host "Building Boost C++ Libraries with these parameters:"
      Write-Host "MSVS_INSTALL_DIR     : ${env:MSVS_INSTALL_DIR}"
      Write-Host "MSVC_BUILD_DIR       : ${env:MSVC_BUILD_DIR}"
      Write-Host "MSVC_CMD_BOOTSTRAP   : ${env:MSVC_CMD_BOOTSTRAP}"
      Write-Host "B2_BIN               : ${env:B2_BIN}"
      Write-Host "B2_TOOLSET           : ${env:B2_TOOLSET}"
      Write-Host "BOOST_INSTALL_DIR    : ${env:BOOST_INSTALL_DIR}"
      Write-Host "BOOST_ADDRESS_MODEL  : ${env:BOOST_ADDRESS_MODEL}"
      Write-Host "BOOST_LINKAGE        : ${env:BOOST_LINKAGE}"
      Write-Host "BOOST_RUNTIME_LINKAGE: ${env:BOOST_RUNTIME_LINKAGE}"
      Write-Host "B2_OPTIONS           : ${env:B2_OPTIONS}"
      & "${PSScriptRoot}\build.bat"
      if (${LastExitCode} -ne 0) {
          throw "Failed to build Boost with BOOST_ADDRESS_MODEL = ${env:BOOST_ADDRESS_MODEL}, BOOST_LINKAGE = ${env:BOOST_LINKAGE}, BOOST_RUNTIME_LINKAGE = ${env:BOOST_RUNTIME_LINKAGE}"
      }
    }
  }
}

Write-Host "Build completed successfully"
