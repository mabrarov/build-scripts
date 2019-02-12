#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

# Enable all versions of TLS
[System.Net.ServicePointManager]::SecurityProtocol = @("Tls12","Tls11","Tls","Ssl3")

# Location of MinGW
$env:MINGW64_HOME = "C:\mingw64"
$env:MINGW32_HOME = "C:\mingw32"

# Location of MSYS2
$env:MSYS_HOME = "C:\msys64"

# Location of 7-Zip
$env:SEVEN_ZIP_HOME = "${env:ProgramFiles}\7-Zip"

# Extension of static library files
$lib_file_extensions = @("a", "lib", "so", "dll")

# List of sub-directories with libraries in ICU install directory
$icu_lib_dirs = @("lib")

$icu_version_underscore = "${env:ICU_VERSION}" -replace "\.", '_'
$icu_archive_file = "${env:DOWNLOAD_DIR}\icu4c-${icu_version_underscore}-src.zip"
$icu_download_url = "${env:ICU_URL}/${env:ICU_VERSION}/icu4c-${icu_version_underscore}-src.zip"

# Prepare patch for ICU
if (-not (Test-Path env:ICU_PATCH_FILE)) {
  $env:ICU_PATCH_FILE = "${env:SCRIPT_DIR}\patches\icu4c-${env:ICU_VERSION}.patch"
}
if (-not (Test-Path -Path "${env:ICU_PATCH_FILE}")) {
  Write-Warning "Patch for chosen version of ICU (${env:ICU_VERSION}) was not found at ${env:ICU_PATCH_FILE}"
  $env:ICU_PATCH_FILE = ""
}
$env:ICU_PATCH_MSYS_FILE = "${env:ICU_PATCH_FILE}" -replace "\\", "/"
$env:ICU_PATCH_MSYS_FILE = "${env:ICU_PATCH_MSYS_FILE}" -replace "^(C):", "/c"

# Build ICU4C
$address_models = @("64", "32")
$icu_linkages = @("shared", "static")
# By some reason ICU names debug version of libraries the same way as release version.
# Let's skip building of debug version of libraries for now.
# $icu_build_types = @("release", "debug")
$icu_build_types = @("release")

# Limit build configurations if user asked for that
if (Test-Path env:ICU_ADDRESS_MODEL) {
  $address_models = @("${env:ICU_ADDRESS_MODEL}")
}
if (Test-Path env:ICU_LINKAGE) {
  $icu_linkages = @("${env:ICU_LINKAGE}")
}
if (Test-Path env:ICU_BUILD_TYPE) {
  $icu_build_types = @("${env:ICU_BUILD_TYPE}")
}

$mingw_version_suffix = "${env:MINGW_VERSION}" -replace "\.", ''
$compiler_target_dir_suffix = "mingw${mingw_version_suffix}"
$icu_downloaded = $false

$env:ICU_PLATFORM = "MinGW"

foreach ($address_model in ${address_models}) {
  $env:ICU_ADDRESS_MODEL = ${address_model}

  # Determine parameters dependent on address model
  switch (${env:ICU_ADDRESS_MODEL}) {
    "32" {
      $env:MINGW_HOME = "${env:MINGW32_HOME}"
      $address_model_target_dir_suffix = "x86"
      $env:ICU_BUILD_MACHINE = "i686-w64-mingw32"
    }
    "64" {
      $env:MINGW_HOME = "${env:MINGW64_HOME}"
      $address_model_target_dir_suffix = "x64"
      $env:ICU_BUILD_MACHINE = "x86_64-w64-mingw32"
    }
    default {
      throw "Unsupported address model: ${env:ICU_ADDRESS_MODEL}"
    }
  }

  $env:ICU_INSTALL_DIR = "${env:TARGET_DIR}\icu-${env:ICU_VERSION}-${address_model_target_dir_suffix}-${compiler_target_dir_suffix}"

  foreach ($icu_linkage in ${icu_linkages}) {
    $env:ICU_LINKAGE = ${icu_linkage}

    $icu_configure_options_linkage = ""
    $icu_build_options_linkage = ""
    switch (${env:ICU_LINKAGE}) {
      "static" {
        $icu_configure_options_linkage = "${icu_configure_options_linkage} --static-runtime"
        $icu_build_options_linkage = "${icu_build_options_linkage} --enable-static --disable-shared"
      }
      "shared" {
        $icu_configure_options_linkage = "${icu_configure_options_linkage}"
        $icu_build_options_linkage = "${icu_build_options_linkage} --enable-shared --disable-static"
      }
      default {
        throw "Unsupported linkage: ${env:ICU_LINKAGE}"
      }
    }

    foreach ($icu_build_type in ${icu_build_types}) {
      $env:ICU_BUILD_TYPE = ${icu_build_type}

      $icu_configure_options_build_type = ""
      $icu_build_options_build_type = ""
      switch (${env:ICU_BUILD_TYPE}) {
        "release" {
          $icu_configure_options_build_type = "${icu_configure_options_build_type}"
          $icu_build_options_build_type = "${icu_build_options_build_type} --enable-release --disable-debug"
        }
        "debug" {
          $icu_configure_options_build_type = "${icu_configure_options_build_type} --enable-debug --disable-release"
          $icu_build_options_build_type = "${icu_build_options_build_type} --enable-debug --disable-release"
        }
        default {
          throw "Unsupported build type: ${env:ICU_BUILD_TYPE}"
        }
      }

      $env:ICU_CONFIGURE_OPTIONS = "${icu_configure_options_linkage} ${icu_configure_options_build_type}"
      $env:ICU_BUILD_OPTIONS = "${icu_build_options_linkage} ${icu_build_options_build_type}"

      $env:ICU_BUILD_DIR = "${env:BUILD_DIR}\icu-${env:ICU_VERSION}\${address_model}\${env:ICU_LINKAGE}\${env:ICU_BUILD_TYPE}"
      $env:ICU_HOME = "${env:ICU_BUILD_DIR}\icu"
      Write-Host "Assuming root folder for sources is: ${env:ICU_HOME}"

      if (Test-Path -Path "${env:ICU_HOME}") {
        Write-Host "Found existing folder ${env:ICU_HOME}, assuming that sources are in place and skipping downloading and unpacking of sources"
      } else {
        if (-not ${icu_downloaded}) {
          if (Test-Path -Path "${icu_archive_file}") {
            Write-Host "Found existing file ${icu_archive_file}, assuming that sources are downloaded and skipping downloading of sources"
          } else {
            # Download ICU
            Write-Host "Downloading ICU (source code archive) from: ${icu_download_url} into: ${icu_archive_file}"
            (New-Object System.Net.WebClient).DownloadFile("${icu_download_url}", "${icu_archive_file}")
          }
          $icu_downloaded = $true
        }

        if (-not (Test-Path -Path "${env:ICU_BUILD_DIR}")) {
          New-Item -path "${env:ICU_BUILD_DIR}" -type directory | out-null
        }

        # Unpack ICU
        Write-Host "Extracting source code archive from ${icu_archive_file} to ${env:ICU_BUILD_DIR}"
        & "${env:SEVEN_ZIP_HOME}\7z.exe" x "${icu_archive_file}" -o"${env:ICU_BUILD_DIR}" -aoa -y
        if (${LastExitCode} -ne 0) {
          throw "Failed to extract ICU from ${icu_archive_file} to ${env:ICU_BUILD_DIR}"
        }
        Write-Host "Extracted source code archive"
      }

      $env:ICU_STAGE_DIR = "${env:ICU_HOME}\dist"
      $env:ICU_STAGE_MSYS_DIR = "${env:ICU_STAGE_DIR}" -replace "\\", "/"
      $env:ICU_STAGE_MSYS_DIR = "${env:ICU_STAGE_MSYS_DIR}" -replace "^(C):", "/c"

      Set-Location -Path "${env:ICU_HOME}\source"

      Write-Host "Building ICU with theses parameters:"
      Write-Host "MINGW_HOME            : ${env:MINGW_HOME}"
      Write-Host "MSYS_HOME             : ${env:MSYS_HOME}"
      Write-Host "ICU_HOME              : ${env:ICU_HOME}"
      Write-Host "ICU_INSTALL_DIR       : ${env:ICU_INSTALL_DIR}"
      Write-Host "ICU_STAGE_DIR         : ${env:ICU_STAGE_DIR}"
      Write-Host "ICU_STAGE_MSYS_DIR    : ${env:ICU_STAGE_MSYS_DIR}"
      Write-Host "ICU_CONFIGURE_OPTIONS : ${env:ICU_CONFIGURE_OPTIONS}"
      Write-Host "ICU_PLATFORM          : ${env:ICU_PLATFORM}"
      Write-Host "ICU_BUILD_MACHINE     : ${env:ICU_BUILD_MACHINE}"
      Write-Host "ICU_BUILD_OPTIONS     : ${env:ICU_BUILD_OPTIONS}"
      Write-Host "ICU_ADDRESS_MODEL     : ${env:ICU_ADDRESS_MODEL}"
      Write-Host "ICU_LINKAGE           : ${env:ICU_LINKAGE}"
      Write-Host "ICU_BUILD_TYPE        : ${env:ICU_BUILD_TYPE}"
      Write-Host "ICU_PATCH_FILE        : ${env:ICU_PATCH_FILE}"
      Write-Host "ICU_PATCH_MSYS_FILE   : ${env:ICU_PATCH_MSYS_FILE}"

      & "${env:SCRIPT_DIR}\build.bat"
      if (${LastExitCode} -ne 0) {
        throw "Failed to build ICU with ICU_ADDRESS_MODEL = ${env:ICU_ADDRESS_MODEL}, ICU_LINKAGE = ${env:ICU_LINKAGE}, ICU_BUILD_TYPE = ${env:ICU_BUILD_TYPE}"
      }

      if (-not (Test-Path -Path "${env:ICU_INSTALL_DIR}")) {
        Write-Host "Copying built ICU from ${env:ICU_STAGE_DIR} to ${env:ICU_INSTALL_DIR}"
        Copy-Item -Force -Recurse -Path "${env:ICU_STAGE_DIR}" -Destination "${env:ICU_INSTALL_DIR}"
      } else {
        Write-Host "Found existing ${env:ICU_INSTALL_DIR}, copying just built libraries"
        foreach ($icu_lib_dir in ${icu_lib_dirs}) {
          foreach ($lib_file_extension in ${lib_file_extensions}) {
            Write-Host "Copying built ICU libraries (${lib_file_extension}) from ${env:ICU_STAGE_DIR}\${icu_lib_dir} to ${env:ICU_INSTALL_DIR}\${icu_lib_dir}"
            $lib_files = Get-ChildItem "${env:ICU_STAGE_DIR}\${icu_lib_dir}\*.${lib_file_extension}"
            foreach ($lib_file in ${lib_files}) {
              $lib_file_name = ${lib_file} | % {$_.Name}
              Copy-Item -Force -Path "${lib_file}" -Destination "${env:ICU_INSTALL_DIR}\${icu_lib_dir}\${lib_file_name}"
            }
          }
        }
      }
    }
  }
}

Write-Host "Build completed successfully"
