#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

FROM microsoft/windowsservercore:10.0.14393.1198

ARG image_version=""

LABEL name="abrarov/win-builder" \
    version="${image_version}" \
    description="Base image for builders on Windows"

ENV SEVEN_ZIP_VERSION=1801 \
    SEVEN_ZIP_DOWNLOAD_URL=http://www.7-zip.org/a

ADD ["app", "C:/app/"]

RUN powershell -ExecutionPolicy Bypass -File "C:\app\install.ps1" && \
    powershell "Remove-Item -Path 'C:\app' -Recurse -Force"
