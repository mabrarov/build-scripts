#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

# Location of MinGW
$env:MINGW64_HOME = "C:\mingw64"
$env:MINGW32_HOME = "C:\mingw32"

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
  Expand-Archive -Force -Path "${boost_archive_file}" -DestinationPath "${env:BUILD_DIR}"
  Write-Host "Extracted source code archive"
}

$env:B2_BIN = "${env:BOOST_ROOT_DIR}\b2.exe"
$env:B2_TOOLSET = "gcc"

# Build Boost.Build
$env:MINGW_HOME = "${env:MINGW64_HOME}"
$env:BOOST_BOOTSTRAP = "${env:BOOST_ROOT_DIR}\bootstrap.bat"
Set-Location -Path "${env:BOOST_ROOT_DIR}"
Write-Host "Building Boost.Build engine"
& "${env:SCRIPT_DIR}\bootstrap.bat"
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

foreach ($address_model in ${address_models}) {
  $env:BOOST_ADDRESS_MODEL = ${address_model}

  # Determine parameters dependent on address model
  switch ($env:BOOST_ADDRESS_MODEL) {
    "32" {
      $env:MINGW_HOME = "${env:MINGW32_HOME}"
      $target_dir_suffix = "x86"
    }
    "64" {
      $env:MINGW_HOME = "${env:MINGW64_HOME}"
      $target_dir_suffix = "x64"
    }
    default {
      throw "Unsupported address model: ${env:BOOST_ADDRESS_MODEL}"
    }
  }

  $mingw_version_suffix = "${env:MINGW_VERSION}" -replace "\.", ''
  $env:BOOST_INSTALL_DIR = "${env:TARGET_DIR}\boost-${env:BOOST_VERSION}-${target_dir_suffix}-mingw${mingw_version_suffix}"
  foreach ($boost_linkage in ${boost_linkages}) {
    $env:BOOST_LINKAGE = ${boost_linkage}
    foreach ($runtime_linkage in ${runtime_linkages}) {
      if (${runtime_linkage} -eq "static" -and -not (${boost_linkage} -eq "static")) {
        # Nothing to do with this type of configuration - just skip it
        continue
      }
      if (${boost_linkage} -eq "shared") {
        # Skip Boost.Serialization when building shared libraries because of https://svn.boost.org/trac/boost/ticket/12450 bug
        $b2_additional_options = "--without-python --without-mpi --without-serialization".Split(" ")
      } else {
        $b2_additional_options = "--without-python --without-mpi".Split(" ")
      }
      $env:BOOST_RUNTIME_LINKAGE = ${runtime_linkage}
      Set-Location -Path "${env:BOOST_ROOT_DIR}"
      Write-Host "Building Boost C++ Libraries with theses parameters:"
      Write-Host "MINGW_HOME              : ${env:MINGW_HOME}"
      Write-Host "B2_BIN                  : ${env:B2_BIN}"
      Write-Host "B2_TOOLSET              : ${env:B2_TOOLSET}"
      Write-Host "BOOST_INSTALL_DIR       : ${env:BOOST_INSTALL_DIR}"
      Write-Host "BOOST_ADDRESS_MODEL     : ${env:BOOST_ADDRESS_MODEL}"
      Write-Host "BOOST_LINKAGE           : ${env:BOOST_LINKAGE}"
      Write-Host "BOOST_RUNTIME_LINKAGE   : ${env:BOOST_RUNTIME_LINKAGE}"
      Write-Host "Additional build options: ${b2_additional_options}"
      & "$env:SCRIPT_DIR\build.bat" ${b2_additional_options}
      if (${LastExitCode} -ne 0) {
          throw "Failed to build Boost with BOOST_ADDRESS_MODEL = ${env:BOOST_ADDRESS_MODEL}, BOOST_LINKAGE = ${env:BOOST_LINKAGE}, BOOST_RUNTIME_LINKAGE = ${env:BOOST_RUNTIME_LINKAGE}"
      }
    }
  }
}

Write-Host "Build completed successfully"
