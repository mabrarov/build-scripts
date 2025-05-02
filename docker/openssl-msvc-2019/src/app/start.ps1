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

# Extension of static library files
$lib_file_extensions = @("a", "lib", "so", "dll", "pdb")

# List of sub-directories with libraries in OpenSSL install directory
$openssl_lib_dirs = @("bin", "lib")

$build_src_dir = "${env:BUILD_DIR}\src"
$env:OPENSSL_HOME = "${build_src_dir}\openssl-${env:OPENSSL_VERSION}"
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
  Write-Host "Extracting source code archive from ${openssl_archive_file} to ${build_src_dir}"
  New-Item -Path "${build_src_dir}" -ItemType "directory" | out-null
  # Path is required to be changed for Gnu tar shipped with MSYS2
  $path_backup = "${env:PATH}"
  $env:PATH = "${env:MSYS_HOME}\usr\bin;${env:PATH}"
  & tar.exe xzf "$(cygpath "${openssl_archive_file}")" -C "$(cygpath "${build_src_dir}")"
  $tar_exit_code = ${LastExitCode}
  $env:PATH = "${path_backup}"
  if (${tar_exit_code} -ne 0) {
    throw "Failed to extract OpenSSL from ${openssl_archive_file} to ${build_src_dir}"
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
$openssl_build_types = @("release", "debug")

# Limit build configurations if user asked for that
if (Test-Path env:OPENSSL_ADDRESS_MODEL) {
  $address_models = @("${env:OPENSSL_ADDRESS_MODEL}")
}
if (Test-Path env:OPENSSL_LINKAGE) {
  $openssl_linkages = @("${env:OPENSSL_LINKAGE}")
}

foreach ($address_model in ${address_models}) {
  $env:OPENSSL_ADDRESS_MODEL = ${address_model}

  # Determine parameters dependent on address model
  switch (${env:OPENSSL_ADDRESS_MODEL}) {
    "32" {
      $env:MSVC_CMD_BOOTSTRAP = "vcvars32.bat"
      $env:OPENSSL_TOOLSET = "VC-WIN32"
      $env:OPENSSL_ARCH = "x86"
      $address_model_target_dir_suffix = "x86"
      $env:NASM_HOME = "${env:NASM32_HOME}"
    }
    "64" {
      $env:MSVC_CMD_BOOTSTRAP = "vcvars64.bat"
      $env:OPENSSL_TOOLSET = "VC-WIN64A"
      $env:OPENSSL_ARCH = "x64"
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

    foreach ($openssl_build_type in ${openssl_build_types}) {
      $env:OPENSSL_BUILD_TYPE = ${openssl_build_type}

      if (${env:OPENSSL_BUILD_TYPE} -eq "debug") {
        $env:OPENSSL_BUILD_TYPE_CONFIG = "--debug"
      } else {
        $env:OPENSSL_BUILD_TYPE_CONFIG = "--release"
      }

      $env:OPENSSL_BUILD_DIR = "${env:BUILD_DIR}\build\openssl-${env:OPENSSL_VERSION}\${address_model}\${env:OPENSSL_LINKAGE}\${env:OPENSSL_BUILD_TYPE}"
      $env:OPENSSL_INSTALL_DIR = "${env:BUILD_DIR}\install\openssl-${env:OPENSSL_VERSION}\${address_model}\${env:OPENSSL_LINKAGE}\${env:OPENSSL_BUILD_TYPE}"
      $env:OPENSSL_TARGET_DIR = "${env:TARGET_DIR}\openssl-${env:OPENSSL_VERSION}-${address_model_target_dir_suffix}-vs2019-${env:OPENSSL_LINKAGE}"

      New-Item -Path "${env:OPENSSL_BUILD_DIR}" -ItemType "directory" | out-null
      New-Item -Path "${env:OPENSSL_INSTALL_DIR}" -ItemType "directory" | out-null

      Write-Host "Building OpenSSL with these parameters:"
      Write-Host "MSVS_INSTALL_DIR      : ${env:MSVS_INSTALL_DIR}"
      Write-Host "MSVC_BUILD_DIR        : ${env:MSVC_BUILD_DIR}"
      Write-Host "MSVC_CMD_BOOTSTRAP    : ${env:MSVC_CMD_BOOTSTRAP}"
      Write-Host "STRAWBERRY_PERL_HOME  : ${env:STRAWBERRY_PERL_HOME}"
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

      if (-not (Test-Path -Path "${env:OPENSSL_TARGET_DIR}")) {
        Write-Host "Copying built OpenSSL from ${env:OPENSSL_INSTALL_DIR} to ${env:OPENSSL_TARGET_DIR}"
        Copy-Item -Force -Recurse -Path "${env:OPENSSL_INSTALL_DIR}" -Destination "${env:OPENSSL_TARGET_DIR}"
      } else {
        Write-Host "Found existing ${env:OPENSSL_TARGET_DIR}, copying just built libraries"
        foreach ($openssl_lib_dir in ${openssl_lib_dirs}) {
          foreach ($lib_file_extension in ${lib_file_extensions}) {
            Write-Host "Copying built OpenSSL libraries (${lib_file_extension}) from ${env:OPENSSL_INSTALL_DIR}\${openssl_lib_dir} to ${env:OPENSSL_TARGET_DIR}\${openssl_lib_dir}"
            $lib_files = Get-ChildItem "${env:OPENSSL_INSTALL_DIR}\${openssl_lib_dir}\*.${lib_file_extension}"
            foreach ($lib_file in ${lib_files}) {
              $lib_file_name = ${lib_file} | % {$_.Name}
              Copy-Item -Force -Path "${lib_file}" `
                -Destination "${env:OPENSSL_TARGET_DIR}\${openssl_lib_dir}\${lib_file_name}"
            }
          }
        }
      }

      Remove-Item -Path "${env:OPENSSL_BUILD_DIR}" -Recurse -Force
      Remove-Item -Path "${env:OPENSSL_INSTALL_DIR}" -Recurse -Force
    }
  }
}

Write-Host "Build completed successfully"
