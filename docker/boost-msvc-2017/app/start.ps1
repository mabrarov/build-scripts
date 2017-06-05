#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the Boost Software License, Version 1.0. (See accompanying
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

# Find location of Visual Studio
$env:MSVS_INSTALL_DIR = vswhere -latest -products Microsoft.VisualStudio.Product.Community -version [15.0,16.0) -requires Microsoft.VisualStudio.Workload.NativeDesktop -property installationPath
$env:MSVC_AUXILARY_DIR = "$env:MSVS_INSTALL_DIR/Community/VC/Auxiliary"
$env:MSVC_BUILD_DIR = "$env:MSVC_AUXILARY_DIR/Build"

# Find location of VC Tools
$env:MSVC_TOOLS_VERSION = [IO.File]::ReadAllText("$env:MSVC_BUILD_DIR\Microsoft.VCToolsVersion.default.txt")
$env:MSVC_TOOLS_DIR = "$env:MSVS_INSTALL_DIR/Community/VC/Tools/MSVC/$env:MSVC_TOOLS_VERSION"

# Create scripts required by Boost.Build
Copy-Item -Force -Path "$env:SCRIPT_DIR\vcvars32.bat" -Destination "$env:MSVC_TOOLS_DIR/bin/HostX86/vcvarsall.bat"
Copy-Item -Force -Path "$env:SCRIPT_DIR\vcvars64.bat" -Destination "$env:MSVC_TOOLS_DIR/bin/HostX64/vcvarsall.bat"

# Download and unpack Boost C++ Libraries
$boost_version_underscore = "$env:BOOST_VERSION" -replace "\.", '_'
$boost_download_url = "$env:BOOST_RELEASE_URL/$env:BOOST_VERSION/source/boost_$boost_version_underscore.zip"

Write-Host "Downloading Boost C++ Libraries (source code archive) from: $boost_download_url"
Invoke-WebRequest -Uri "$boost_download_url" -OutFile "$env:TMP\boost.zip"

Write-Host "Extracting source code archive to: $env:BUILD_DIR"
Expand-Archive "$env:TMP\boost.zip" -DestinationPath "$env:BUILD_DIR"

$env:BOOST_ROOT_DIR = "$env:BUILD_DIR\boost_$boost_version_underscore"
Write-Host "Extracted source code archive, assuming root folder for sources is: $env:BOOST_ROOT_DIR"

$env:B2_BIN = "$env:BOOST_ROOT_DIR\b2.exe"
$env:B2_TOOLSET = "msvc-15.0"

$env:MSVC_CMD_BOOTSTRAP = "vcvars64.bat"
$env:BOOST_BOOTSTRAP = "$env:BOOST_ROOT_DIR\bootstrap.bat"

# Build Boost.Build
Set-Location -Path "$env:BOOST_ROOT_DIR"
& "$env:SCRIPT_DIR\bootstrap.bat"
if ($LastExitCode -ne 0) {
  throw "Failed to build Boost.Build"
}

# Build Boost C++ Libraries
$msvc_cmd_bootstraps = @("vcvars64.bat", "vcvars32.bat")
$address_models = @("64", "32")
$target_dir_suffixes = @("x64", "x86")
$boost_linkages = @("shared", "static")
$runtime_linkages = @("shared", "static")

for ($address_model_idx = 0; $address_model_idx -lt 2; $address_model_idx++) {
  $env:MSVC_CMD_BOOTSTRAP = $msvc_cmd_bootstraps[$address_model_idx]
  $env:BOOST_ADDRESS_MODEL = $address_models[$address_model_idx]
  $target_dir_suffix = $target_dir_suffixes[$address_model_idx]
  $env:BOOST_INSTALL_DIR = "$env:TARGET_DIR\boost-$env:BOOST_VERSION-$target_dir_suffix-vs2017"
  foreach ($boost_linkage in $runtime_linkages) {
    $env:BOOST_LINKAGE = $boost_linkage
    foreach ($runtime_linkage in $runtime_linkages) {
      if ($runtime_linkage -eq "shared" -and -not ($boost_linkage -eq "shared")) {
        # Nothing to do with this type of configuration - just skip it
        continue
      }
      $env:BOOST_RUNTIME_LINKAGE = $runtime_linkage
      Set-Location -Path "$env:BOOST_ROOT_DIR"
      Write-Host "Building Boost C++ Libraries with theses parameters:"
      Write-Host "MSVC_CMD_BOOTSTRAP   : $env:MSVC_CMD_BOOTSTRAP"
      Write-Host "B2_BIN               : $env:B2_BIN"
      Write-Host "B2_TOOLSET           : $env:B2_TOOLSET"
      Write-Host "BOOST_INSTALL_DIR    : $env:BOOST_INSTALL_DIR"
      Write-Host "BOOST_ADDRESS_MODEL  : $env:BOOST_ADDRESS_MODEL"
      Write-Host "BOOST_LINKAGE        : $env:BOOST_LINKAGE"
      Write-Host "BOOST_RUNTIME_LINKAGE: $env:BOOST_RUNTIME_LINKAGE"
      & "$env:SCRIPT_DIR\build.bat"
      if ($LastExitCode -ne 0) {
          throw "Failed to build Boost with BOOST_ADDRESS_MODEL = $env:BOOST_ADDRESS_MODEL, BOOST_LINKAGE = $env:BOOST_LINKAGE, BOOST_RUNTIME_LINKAGE = $env:BOOST_RUNTIME_LINKAGE"
      }
    }
  }
}
