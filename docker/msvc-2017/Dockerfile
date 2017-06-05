#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the Boost Software License, Version 1.0. (See accompanying
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
#

FROM microsoft/windowsservercore:10.0.14393.1198

ENV MSVS_INSTALL_URL=https://aka.ms/vs/15/release/vs_community.exe \
    MSVS_INSTALL_TMP_DIR=C:\vs_install \
    MSVS_INSTALL_EXECUTABLE=vs_community.exe \
    VSWHERE_RELEASE_URL=https://github.com/Microsoft/vswhere/releases/download \
    VSWHERE_VERSION=1.0.62 \
    VSWHERE_EXECTUABLE=vswhere.exe

LABEL name="abrarov/msvc-2017" \
    version="0.0.1" \
    description="Microsoft Visual C++ as part of Microsoft Visual Studio 2017 Community"

RUN mkdir "%MSVS_INSTALL_TMP_DIR%" && \
    powershell "Invoke-WebRequest -Uri \"$env:MSVS_INSTALL_URL\" -OutFile \"$env:MSVS_INSTALL_TMP_DIR\$env:MSVS_INSTALL_EXECUTABLE\"" && \
    powershell "Start-Process -FilePath \"$env:MSVS_INSTALL_TMP_DIR\$env:MSVS_INSTALL_EXECUTABLE\" -ArgumentList (\"--locale en-US\", \"--quiet\", \"--norestart\", \"--wait\", \"--nocache\", \"--add Microsoft.VisualStudio.Workload.NativeDesktop\", \"--add Microsoft.VisualStudio.Component.VC.ATLMFC\", \"--includeRecommended\") -Wait" && \
    rd /q /s "%MSVS_INSTALL_TMP_DIR%" && \
    powershell "Invoke-WebRequest -Uri \"$env:VSWHERE_RELEASE_URL/$env:VSWHERE_VERSION/$env:VSWHERE_EXECTUABLE\" -OutFile \"$env:SystemRoot\$env:VSWHERE_EXECTUABLE\""
