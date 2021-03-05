#
# Copyright (c) 2019 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

# Stop immediately if any error happens
$ErrorActionPreference = "Stop"

# Enable all versions of TLS
[System.Net.ServicePointManager]::SecurityProtocol = @("Tls12","Tls11","Tls","Ssl3")

# Download and install LLVM for building Qt documentation
$llvm_url = "${env:LLVM_URL}/llvmorg-${env:LLVM_VERSION}/${env:LLVM_DIST_NAME}"
$llvm_dist = "${env:TMP}\${env:LLVM_DIST_NAME}"
Write-Host "Downloading LLVM from ${llvm_url} into ${llvm_dist}"
(New-Object System.Net.WebClient).DownloadFile("${llvm_url}", "${llvm_dist}")
Write-Host "Installing LLVM into ${env:LLVM_INSTALL_DIR}"
$p = Start-Process -FilePath "${llvm_dist}" -ArgumentList ("/S") -Wait -PassThru
if (${p}.ExitCode -ne 0) {
  throw "Failed to install LLVM"
}
Write-Host "LLVM ${env:LLVM_VERSION} installed"

# Download and install jom
$jom_url_version_suffix = "${env:JOM_VERSION}" -replace "\.", "_"
$jom_dist_filename = "jom_${jom_url_version_suffix}.zip"
$jom_url = "${env:JOM_URL}/${jom_dist_filename}"
$jom_dist = "${env:TMP}\${jom_dist_filename}"
Write-Host "Downloading jom from ${jom_url} into ${jom_dist}"
(New-Object System.Net.WebClient).DownloadFile("${jom_url}", "${jom_dist}")
Write-Host "Installing jom into ${env:JOM_HOME}"
& "${env:SEVEN_ZIP_HOME}\7z.exe" x "${jom_dist}" -o"${env:JOM_HOME}" -aoa -y -bd | out-null
Write-Host "Jom ${env:JOM_VERSION} installed"

# Download and install Node.js for buildin QtWebEngine
$node_js_dist_filename = "node-v${env:NODE_JS_VERSION}-win-x64.zip"
$node_js_url = "${env:NODE_JS_URL}/v${env:NODE_JS_VERSION}/${node_js_dist_filename}"
$node_js_dist = "${env:TMP}\${node_js_dist_filename}"
Write-Host "Downloading Node.js from ${node_js_url} into ${node_js_dist}"
(New-Object System.Net.WebClient).DownloadFile("${node_js_url}", "${node_js_dist}")
Write-Host "Installing Node.js into ${env:NODE_JS_HOME}"
& "${env:SEVEN_ZIP_HOME}\7z.exe" x "${node_js_dist}" -o"${env:TMP}" -aoa -y -bd | out-null
Move-Item -Path "${env:TMP}\node-v${env:NODE_JS_VERSION}-win-x64" -Destination "${env:NODE_JS_HOME}" -force
Write-Host "Node.js ${env:NODE_JS_VERSION} installed"

# Cleanup
Write-Host "Removing all files and directories from ${env:TMP}"
Remove-Item -Path "${env:TMP}\*" -Recurse -Force
