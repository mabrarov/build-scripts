#
# Copyright (c) 2025 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

# Enable all versions of TLS
[System.Net.ServicePointManager]::SecurityProtocol = @("Tls12","Tls11","Tls","Ssl3")

# Find location of Visual Studio
$env:MSVS_INSTALL_DIR = &vswhere --% -latest -products Microsoft.VisualStudio.Product.BuildTools -version [17.0,18.0) -requires Microsoft.VisualStudio.Workload.VCTools -property installationPath
$env:MSVC_AUXILARY_DIR = "${env:MSVS_INSTALL_DIR}\VC\Auxiliary"
$env:MSVC_BUILD_DIR = "${env:MSVC_AUXILARY_DIR}\Build"

# Extension of static library files
$lib_file_extensions = @("a", "lib", "so", "dll")

# List of sub-directories with libraries in ICU install directory
$icu_lib_dirs = @("bin", "lib")

$icu_version_major = "${env:ICU_VERSION}" -replace "([0-9]+)(\..*)?", '$1'
$icu_version_underscore = "${env:ICU_VERSION}" -replace "\.", '_'
$icu_version_dash = "${env:ICU_VERSION}" -replace "\.", '-'
$icu_archive_file = "${env:DOWNLOAD_DIR}\icu4c-${icu_version_underscore}-src.zip"
$icu_download_url = "${env:ICU_URL}/release-${icu_version_dash}/icu4c-${icu_version_underscore}-src.zip"

if (Test-Path -Path "${icu_archive_file}") {
  Write-Host "Found existing file ${icu_archive_file}, assuming that sources are downloaded and skipping downloading of sources"
} else {
  # Download ICU
  Write-Host "Downloading ICU (source code archive) from: ${icu_download_url} into: ${icu_archive_file}"
  (New-Object System.Net.WebClient).DownloadFile("${icu_download_url}", "${icu_archive_file}")
}

# Prepare patch for ICU
if (-not (Test-Path env:ICU_PATCH_FILE)) {
  $env:ICU_PATCH_FILE = "${PSScriptRoot}\patches\icu4c-${env:ICU_VERSION}.patch"
}
if (-not (Test-Path -Path "${env:ICU_PATCH_FILE}")) {
  Write-Warning "Patch for chosen version of ICU (${env:ICU_VERSION}) was not found at ${env:ICU_PATCH_FILE}"
  $env:ICU_PATCH_FILE = ""
}

# Build ICU4C
$address_models = @("64", "32")
$icu_linkages = @("shared", "static")
$icu_build_types = @("release", "debug")

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

$compiler_target_dir_suffix = "vs2022"
$env:ICU_PLATFORM = "MSYS/MSVC"

foreach ($address_model in ${address_models}) {
  $env:ICU_ADDRESS_MODEL = ${address_model}

  # Determine parameters dependent on address model
  switch (${env:ICU_ADDRESS_MODEL}) {
    "32" {
      $env:MSVC_CMD_BOOTSTRAP = "vcvars32.bat"
      $address_model_target_dir_suffix = "x86"
      $env:ICU_BUILD_MACHINE = "i686-w64-mingw32msvc"
    }
    "64" {
      $env:MSVC_CMD_BOOTSTRAP = "vcvars64.bat"
      $address_model_target_dir_suffix = "x64"
      $env:ICU_BUILD_MACHINE = "x86_64-w64-mingw32msvc"
    }
    default {
      throw "Unsupported address model: ${env:ICU_ADDRESS_MODEL}"
    }
  }

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

      $icu_configure_options_build_type = ${icu_configure_options_build_type}.Trim()
      $icu_build_options_build_type = ${icu_build_options_build_type}.Trim()
      $env:ICU_CONFIGURE_OPTIONS = "${icu_configure_options_linkage} ${icu_configure_options_build_type}"
      $env:ICU_CONFIGURE_OPTIONS = ${env:ICU_CONFIGURE_OPTIONS}.Trim()
      $env:ICU_BUILD_OPTIONS = "${icu_build_options_linkage} ${icu_build_options_build_type}"
      $env:ICU_BUILD_OPTIONS = ${env:ICU_BUILD_OPTIONS}.Trim()
      $env:ICU_BUILD_DIR = "${env:BUILD_DIR}\icu-${env:ICU_VERSION}\${address_model}\${env:ICU_LINKAGE}\${env:ICU_BUILD_TYPE}"
      $env:ICU_HOME = "${env:ICU_BUILD_DIR}\icu"
      Write-Host "Assuming root folder for sources is: ${env:ICU_HOME}"

      if (Test-Path -Path "${env:ICU_HOME}") {
        Write-Host "Found existing folder ${env:ICU_HOME}, assuming that sources are in place and skipping downloading and unpacking of sources"
      } else {
        if (-not (Test-Path -Path "${env:ICU_BUILD_DIR}")) {
          New-Item -Path "${env:ICU_BUILD_DIR}" -ItemType "directory" | out-null
        }

        # Unpack ICU
        Write-Host "Extracting source code archive from ${icu_archive_file} to ${env:ICU_BUILD_DIR}"
        & "${env:SEVEN_ZIP_HOME}\7z.exe" x "${icu_archive_file}" -o"${env:ICU_BUILD_DIR}" -aoa -y -bd | out-null
        if (${LastExitCode} -ne 0) {
          throw "Failed to extract ICU from ${icu_archive_file} to ${env:ICU_BUILD_DIR}"
        }
        Write-Host "Extracted source code archive"
      }

      # Patch ICU
      if ("${env:ICU_PATCH_FILE}" -ne "") {
        $icu_home_source = "${env:ICU_HOME}\source"
        Write-Host "Patching ICU located at ${icu_home_source} with ${env:ICU_PATCH_FILE}"
        Set-Location -Path "${icu_home_source}"
        $path_backup = "${env:PATH}"
        $env:PATH = "${env:MSYS_HOME}\usr\bin;${env:PATH}"
        & patch.exe -uNf -p0 -i "${env:ICU_PATCH_FILE}"
        $patch_exit_code = ${LastExitCode}
        $env:PATH = "${path_backup}"
        if (${patch_exit_code} -ne 0) {
          throw "Failed to patch ICU located at ${icu_home_source} with ${env:ICU_PATCH_FILE}"
        }
      }

      $env:ICU_INSTALL_DIR = "${env:ICU_BUILD_DIR}\install"
      $env:ICU_TARGET_DIR = "${env:TARGET_DIR}\icu4c-${env:ICU_VERSION}-${address_model_target_dir_suffix}-${compiler_target_dir_suffix}-${env:ICU_LINKAGE}"

      Write-Host "Building ICU with these parameters:"
      Write-Host "MSVS_INSTALL_DIR     : ${env:MSVS_INSTALL_DIR}"
      Write-Host "MSVC_BUILD_DIR       : ${env:MSVC_BUILD_DIR}"
      Write-Host "MSVC_CMD_BOOTSTRAP   : ${env:MSVC_CMD_BOOTSTRAP}"
      Write-Host "MSYS_HOME            : ${env:MSYS_HOME}"
      Write-Host "ICU_HOME             : ${env:ICU_HOME}"
      Write-Host "ICU_TARGET_DIR       : ${env:ICU_TARGET_DIR}"
      Write-Host "ICU_INSTALL_DIR      : ${env:ICU_INSTALL_DIR}"
      Write-Host "ICU_CONFIGURE_OPTIONS: ${env:ICU_CONFIGURE_OPTIONS}"
      Write-Host "ICU_PLATFORM         : ${env:ICU_PLATFORM}"
      Write-Host "ICU_BUILD_MACHINE    : ${env:ICU_BUILD_MACHINE}"
      Write-Host "ICU_BUILD_OPTIONS    : ${env:ICU_BUILD_OPTIONS}"
      Write-Host "ICU_ADDRESS_MODEL    : ${env:ICU_ADDRESS_MODEL}"
      Write-Host "ICU_LINKAGE          : ${env:ICU_LINKAGE}"
      Write-Host "ICU_BUILD_TYPE       : ${env:ICU_BUILD_TYPE}"

      & "${PSScriptRoot}\build.bat"
      if (${LastExitCode} -ne 0) {
        throw "Failed to build ICU with ICU_ADDRESS_MODEL = ${env:ICU_ADDRESS_MODEL}, ICU_LINKAGE = ${env:ICU_LINKAGE}, ICU_BUILD_TYPE = ${env:ICU_BUILD_TYPE}"
      }

      $icu_install_bin_dir = "${env:ICU_INSTALL_DIR}\bin"
      $icu_install_lib_dir = "${env:ICU_INSTALL_DIR}\lib"
      Write-Host "Moving *${icu_version_major}.dll files from ${icu_install_lib_dir} directory to ${icu_install_bin_dir}"
      Move-Item -Path "${icu_install_lib_dir}\*${icu_version_major}.dll" -Destination "${icu_install_bin_dir}"

      Write-Host "Removing *.dll files from ${icu_install_lib_dir} directory"
      Remove-Item -Path "${icu_install_lib_dir}\*.dll"
      
      if (-not (Test-Path -Path "${env:ICU_TARGET_DIR}")) {
        Write-Host "Copying built ICU from ${env:ICU_INSTALL_DIR} to ${env:ICU_TARGET_DIR}"
        Copy-Item -Force -Recurse -Path "${env:ICU_INSTALL_DIR}" -Destination "${env:ICU_TARGET_DIR}"
      } else {
        Write-Host "Found existing ${env:ICU_TARGET_DIR}, copying just built libraries"
        foreach ($icu_lib_dir in ${icu_lib_dirs}) {
          foreach ($lib_file_extension in ${lib_file_extensions}) {
            Write-Host "Copying built ICU libraries (${lib_file_extension}) from ${env:ICU_INSTALL_DIR}\${icu_lib_dir} to ${env:ICU_TARGET_DIR}\${icu_lib_dir}"
            $lib_files = Get-ChildItem "${env:ICU_INSTALL_DIR}\${icu_lib_dir}\*.${lib_file_extension}"
            foreach ($lib_file in ${lib_files}) {
              $lib_file_name = ${lib_file} | % {$_.Name}
              Copy-Item -Force -Path "${lib_file}" -Destination "${env:ICU_TARGET_DIR}\${icu_lib_dir}\${lib_file_name}"
            }
          }
        }
      }

      Set-Location -Path "${env:BUILD_DIR}"
      Remove-Item -Path "${env:ICU_BUILD_DIR}" -Recurse -Force
    }
  }
}

Write-Host "Build completed successfully"
