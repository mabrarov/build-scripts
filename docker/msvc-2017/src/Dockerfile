#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

FROM abrarov/windows-dev:2.9.0

ENV MSVS_VERSION="15" \
    MSVS_URL="https://aka.ms/vs" \
    MSVS_DIST_NAME="vs_community.exe" \
    VSWHERE_URL="https://github.com/Microsoft/vswhere/releases/download" \
    VSWHERE_VERSION="2.8.4" \
    VSWHERE_DIST_NAME="vswhere.exe"

ADD ["app", "C:/app/"]

RUN powershell -ExecutionPolicy Bypass -File "C:\app\install.ps1" && \
    powershell "Remove-Item -Path 'C:\app' -Recurse -Force"

ARG image_version=""
ARG image_revision=""

LABEL name="abrarov/msvc-2017" \
    version="${image_version}" \
    revision="${image_revision}" \
    description="Microsoft Visual C++ as part of Microsoft Visual Studio 2017 Community"
