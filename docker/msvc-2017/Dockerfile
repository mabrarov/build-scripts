#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the Boost Software License, Version 1.0. (See accompanying
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
#

FROM microsoft/windowsservercore:10.0.14393.1198

LABEL name="abrarov/msvc-2017" \
    version="1.0.2" \
    description="Microsoft Visual C++ as part of Microsoft Visual Studio 2017 Community"

ENV MSVS_INSTALL_URL=https://aka.ms/vs/15/release/vs_community.exe \
    MSVS_INSTALL_EXECUTABLE=vs_community.exe \
    VSWHERE_RELEASE_URL=https://github.com/Microsoft/vswhere/releases/download \
    VSWHERE_VERSION=2.6.7 \
    VSWHERE_EXECTUABLE=vswhere.exe

ADD ["app", "C:/app/"]

RUN powershell -ExecutionPolicy Bypass -File "C:\app\install.ps1" && \
    powershell "Remove-Item -Path 'C:\app' -Recurse -Force"
