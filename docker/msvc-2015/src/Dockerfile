#
# Copyright (c) 2019 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

FROM abrarov/windows-dev:2.9.0

ENV MSVS_VERSION="14" \
    MSVS_URL="https://go.microsoft.com/fwlink/?LinkId=532606&clcid=0x409" \
    MSVS_DIST_NAME="vs_community.exe" \
    VSWHERE_URL="https://github.com/Microsoft/vswhere/releases/download" \
    VSWHERE_VERSION="2.8.4" \
    VSWHERE_DIST_NAME="vswhere.exe"

ADD ["app", "C:/app/"]

RUN powershell -ExecutionPolicy Bypass -File "C:\app\install.ps1" && \
    powershell "Remove-Item -Path 'C:\app' -Recurse -Force"

ARG image_version=""
ARG image_revision=""

LABEL name="abrarov/msvc-2015" \
    version="${image_version}" \
    revision="${image_revision}" \
    description="Microsoft Visual C++ as part of Microsoft Visual Studio 2017 Community"
