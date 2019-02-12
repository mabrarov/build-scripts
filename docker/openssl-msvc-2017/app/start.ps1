#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
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

# Find location of VC Tools
$env:MSVC_TOOLS_VERSION = [IO.File]::ReadAllLines("${env:MSVC_BUILD_DIR}\Microsoft.VCToolsVersion.default.txt")[0].trimend()
$env:MSVC_TOOLS_DIR = "${env:MSVS_INSTALL_DIR}\VC\Tools\MSVC\${env:MSVC_TOOLS_VERSION}"
Write-Host "MSVC_TOOLS_DIR: ${env:MSVC_TOOLS_DIR}"

# Location of MSYS2
$env:MSYS_HOME = "C:\msys64"

# Location of 7-Zip
$env:SEVEN_ZIP_HOME = "${env:ProgramFiles}\7-Zip"

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
  $env:OPENSSL_PATCH_FILE = "${env:SCRIPT_DIR}\patches\openssl-${env:OPENSSL_VERSION}.patch"
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
      $env:OPENSSL_TOOLSET = "VC-WIN32"
      $env:OPENSSL_BOOTSTRAP = "do_ms.bat"
      $address_model_target_dir_suffix = "x86"
    }
    "64" {
      $env:MSVC_CMD_BOOTSTRAP = "vcvars64.bat"
      $env:OPENSSL_TOOLSET = "VC-WIN64A"
      $env:OPENSSL_BOOTSTRAP = "do_win64a.bat"
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
        $env:OPENSSL_MAKE_FILE = "ntdll.mak"
      }
      "static" {
        $env:OPENSSL_MAKE_FILE = "nt.mak"
      }
      default {
        throw "Unsupported linkage: ${env:OPENSSL_LINKAGE}"
      }
    }

    foreach ($openssl_build_type in ${openssl_build_types}) {
      $env:OPENSSL_BUILD_TYPE = ${openssl_build_type}

      if (${env:OPENSSL_BUILD_TYPE} -eq "debug") {
        $env:OPENSSL_TOOLSET = "debug-${env:OPENSSL_TOOLSET}"
      }

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
          New-Item -path "${env:OPENSSL_BUILD_DIR}" -type directory | out-null
        }

        # Unpack OpenSSL
        if (-not (Test-Path -Path "${openssl_tar_archive_file}")) {
          Write-Host "Extracting source code archive from ${openssl_archive_file} to ${openssl_tar_archive_dir}"
          & "${env:SEVEN_ZIP_HOME}\7z.exe" x "${openssl_archive_file}" -o"${openssl_tar_archive_dir}" -aoa -y
          if (${LastExitCode} -ne 0) {
            throw "Failed to extract OpenSSL from ${openssl_archive_file} to ${openssl_tar_archive_dir}"
          }
        }
        Write-Host "Extracting source code archive from ${openssl_tar_archive_file} to ${env:OPENSSL_BUILD_DIR}"
        & "${env:SEVEN_ZIP_HOME}\7z.exe" x "${openssl_tar_archive_file}" -o"${env:OPENSSL_BUILD_DIR}" -aoa -y
        if (${LastExitCode} -ne 0) {
          throw "Failed to extract OpenSSL from ${openssl_tar_archive_file} to ${env:OPENSSL_BUILD_DIR}"
        }
        Write-Host "Extracted source code archive"
      }

      $env:OPENSSL_INSTALL_DIR = "${env:TARGET_DIR}\openssl-${env:OPENSSL_VERSION}-${address_model_target_dir_suffix}-vs2017-${env:OPENSSL_LINKAGE}"
      $env:OPENSSL_STAGE_DIR = "${env:OPENSSL_HOME}\dist"

      Set-Location -Path "${env:OPENSSL_HOME}"

      Write-Host "Building OpenSSL with theses parameters:"
      Write-Host "OPENSSL_HOME          : ${env:OPENSSL_HOME}"
      Write-Host "OPENSSL_INSTALL_DIR   : ${env:OPENSSL_INSTALL_DIR}"
      Write-Host "OPENSSL_STAGE_DIR     : ${env:OPENSSL_STAGE_DIR}"
      Write-Host "OPENSSL_TOOLSET       : ${env:OPENSSL_TOOLSET}"
      Write-Host "OPENSSL_ADDRESS_MODEL : ${env:OPENSSL_ADDRESS_MODEL}"
      Write-Host "OPENSSL_LINKAGE       : ${env:OPENSSL_LINKAGE}"
      Write-Host "OPENSSL_BUILD_TYPE    : ${env:OPENSSL_BUILD_TYPE}"
      Write-Host "OPENSSL_BOOTSTRAP     : ${env:OPENSSL_BOOTSTRAP}"
      Write-Host "OPENSSL_MAKE_FILE     : ${env:OPENSSL_MAKE_FILE}"

      & "${env:SCRIPT_DIR}\build.bat"
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
              Copy-Item -Force -Path "${lib_file}" -Destination "${env:OPENSSL_INSTALL_DIR}\${openssl_lib_dir}\${lib_file_name}"
            }
          }
        }
      }
    }
  }
}

Write-Host "Build completed successfully"
