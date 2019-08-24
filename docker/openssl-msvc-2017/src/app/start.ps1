#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

# Enable all versions of TLS
[System.Net.ServicePointManager]::SecurityProtocol = @("Tls12","Tls11","Tls","Ssl3")

# Find location of Visual Studio
$env:MSVS_INSTALL_DIR = &vswhere --% -latest -products Microsoft.VisualStudio.Product.Community -version [15.0,16.0) -requires Microsoft.VisualStudio.Workload.NativeDesktop -property installationPath
$env:MSVC_AUXILARY_DIR = "${env:MSVS_INSTALL_DIR}\VC\Auxiliary"
$env:MSVC_BUILD_DIR = "${env:MSVC_AUXILARY_DIR}\Build"

# Required for unpacking with tar
$env:PATH = "${env:PATH};${env:MSYS_HOME}\usr\bin"

# Extension of static library files
$lib_file_extensions = @("a", "lib", "so", "dll")

# List of sub-directories with libraries in OpenSSL install directory
$openssl_lib_dirs = @("lib")

$openssl_download_url = "${env:OPENSSL_URL}/openssl-${env:OPENSSL_VERSION}.tar.gz"

$openssl_archive_file = "${env:DOWNLOAD_DIR}\openssl-${env:OPENSSL_VERSION}.tar.gz"
$openssl_tar_archive_dir = "${env:TMP}"
$openssl_tar_archive_file_name = "openssl-${env:OPENSSL_VERSION}.tar"
$openssl_tar_archive_file = "${openssl_tar_archive_dir}\${openssl_tar_archive_file_name}"

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
$openssl_build_types = @("release", "debug")

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
      $env:MSVC_CMD_BOOTSTRAP = "vcvars32.bat"
      $env:OPENSSL_BASE_TOOLSET = "VC-WIN32"
      $env:OPENSSL_ARCH = "x86"
      $address_model_target_dir_suffix = "x86"
    }
    "64" {
      $env:MSVC_CMD_BOOTSTRAP = "vcvars64.bat"
      $env:OPENSSL_BASE_TOOLSET = "VC-WIN64A"
      $env:OPENSSL_ARCH = "x64"
      $address_model_target_dir_suffix = "x64"
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
        $env:OPENSSL_DLL_STR = "dll"
        $env:OPENSSL_LINK_STR = ""
        $openssl_runtime_suffix = "MD"
      }
      "static" {
        $env:OPENSSL_DLL_STR = ""
        $env:OPENSSL_LINK_STR = "static_lib"
        $openssl_runtime_suffix = "MT"
      }
      default {
        throw "Unsupported linkage: ${env:OPENSSL_LINKAGE}"
      }
    }

    foreach ($openssl_build_type in ${openssl_build_types}) {
      $env:OPENSSL_BUILD_TYPE = ${openssl_build_type}

      if (${env:OPENSSL_BUILD_TYPE} -eq "debug") {
        $env:OPENSSL_TOOLSET = "debug-${env:OPENSSL_BASE_TOOLSET}"
        $env:OPENSSL_BUILD_STR_PLAIN = "debug"
        $env:OPENSSL_BUILD_STR = "debug_lib"
        $openssl_libsuffix = "d"
      } else {
        $env:OPENSSL_TOOLSET = "${env:OPENSSL_BASE_TOOLSET}"
        $env:OPENSSL_BUILD_STR_PLAIN = ""
        $env:OPENSSL_BUILD_STR = ""
        $openssl_libsuffix = ""
      }

      $env:OPENSSL_RUNTIME_FULL_SUFFIX = "${openssl_runtime_suffix}${openssl_libsuffix}"

      $env:OPENSSL_BUILD_DIR = "${env:BUILD_DIR}\openssl-${env:OPENSSL_VERSION}\${address_model}\${env:OPENSSL_LINKAGE}\${env:OPENSSL_BUILD_TYPE}"
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

      $env:OPENSSL_INSTALL_DIR = "${env:TARGET_DIR}\openssl-${env:OPENSSL_VERSION}-${address_model_target_dir_suffix}-vs2017-${env:OPENSSL_LINKAGE}"
      $env:OPENSSL_STAGE_DIR = "${env:OPENSSL_HOME}\dist"

      Set-Location -Path "${env:OPENSSL_HOME}"

      Write-Host "Building OpenSSL with these parameters:"
      Write-Host "MSVS_INSTALL_DIR            : ${env:MSVS_INSTALL_DIR}"
      Write-Host "MSVC_BUILD_DIR              : ${env:MSVC_BUILD_DIR}"
      Write-Host "MSVC_CMD_BOOTSTRAP          : ${env:MSVC_CMD_BOOTSTRAP}"
      Write-Host "ACTIVE_PERL_HOME            : ${env:ACTIVE_PERL_HOME}"
      Write-Host "MSYS_HOME                   : ${env:MSYS_HOME}"
      Write-Host "OPENSSL_HOME                : ${env:OPENSSL_HOME}"
      Write-Host "OPENSSL_INSTALL_DIR         : ${env:OPENSSL_INSTALL_DIR}"
      Write-Host "OPENSSL_STAGE_DIR           : ${env:OPENSSL_STAGE_DIR}"
      Write-Host "OPENSSL_ADDRESS_MODEL       : ${env:OPENSSL_ADDRESS_MODEL}"
      Write-Host "OPENSSL_LINKAGE             : ${env:OPENSSL_LINKAGE}"
      Write-Host "OPENSSL_BUILD_TYPE          : ${env:OPENSSL_BUILD_TYPE}"
      Write-Host "OPENSSL_BASE_TOOLSET        : ${env:OPENSSL_BASE_TOOLSET}"
      Write-Host "OPENSSL_TOOLSET             : ${env:OPENSSL_TOOLSET}"
      Write-Host "OPENSSL_BUILD_STR_PLAIN     : ${env:OPENSSL_BUILD_STR_PLAIN}"
      Write-Host "OPENSSL_BUILD_STR           : ${env:OPENSSL_BUILD_STR}"
      Write-Host "OPENSSL_LINK_STR            : ${env:OPENSSL_LINK_STR}"
      Write-Host "OPENSSL_DLL_STR             : ${env:OPENSSL_DLL_STR}"
      Write-Host "OPENSSL_ARCH                : ${env:OPENSSL_ARCH}"
      Write-Host "OPENSSL_RUNTIME_FULL_SUFFIX : ${env:OPENSSL_RUNTIME_FULL_SUFFIX}"
      Write-Host "OPENSSL_PATCH_FILE          : ${env:OPENSSL_PATCH_FILE}"
      Write-Host "OPENSSL_PATCH_MSYS_FILE     : ${env:OPENSSL_PATCH_MSYS_FILE}"

      & "${PSScriptRoot}\build.bat"
      if (${LastExitCode} -ne 0) {
        throw "Failed to build OpenSSL with OPENSSL_ADDRESS_MODEL = ${env:OPENSSL_ADDRESS_MODEL}, OPENSSL_LINKAGE = ${env:OPENSSL_LINKAGE}, OPENSSL_BUILD_TYPE = ${env:OPENSSL_BUILD_TYPE}"
      }

      if (-not (Test-Path -Path "${env:OPENSSL_INSTALL_DIR}")) {
        Write-Host "Copying built OpenSSL from ${env:OPENSSL_STAGE_DIR} to ${env:OPENSSL_INSTALL_DIR}"
        Copy-Item -Force -Recurse -Path "${env:OPENSSL_STAGE_DIR}" -Destination "${env:OPENSSL_INSTALL_DIR}"
      } else {
        Write-Host "Found existing ${env:OPENSSL_INSTALL_DIR}, copying just built libraries"
        foreach ($openssl_lib_dir in ${openssl_lib_dirs}) {
          foreach ($lib_file_extension in ${lib_file_extensions}) {
            Write-Host "Copying built OpenSSL libraries (${lib_file_extension}) from ${env:OPENSSL_STAGE_DIR}\${openssl_lib_dir} to ${env:OPENSSL_INSTALL_DIR}\${openssl_lib_dir}"
            $lib_files = Get-ChildItem "${env:OPENSSL_STAGE_DIR}\${openssl_lib_dir}\*.${lib_file_extension}"
            foreach ($lib_file in ${lib_files}) {
              $lib_file_name = ${lib_file} | % {$_.Name}
              Copy-Item -Force -Path "${lib_file}" `
                -Destination "${env:OPENSSL_INSTALL_DIR}\${openssl_lib_dir}\${lib_file_name}"
            }
          }
        }
      }
    }
  }
}

Write-Host "Build completed successfully"
