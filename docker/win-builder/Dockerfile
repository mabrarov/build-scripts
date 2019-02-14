#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

FROM microsoft/windowsservercore:10.0.14393.1198

ARG image_version=""
ARG image_revision=""

LABEL name="abrarov/win-builder" \
    version="${image_version}" \
    revision="${image_revision}" \
    description="Base image for builders on Windows"

ENV DOWNLOAD_DIR=C:\\download \
    BUILD_DIR=C:\\build \
    TARGET_DIR=C:\\target \
    SEVEN_ZIP_VERSION=1801 \
    SEVEN_ZIP_DOWNLOAD_URL=http://www.7-zip.org/a \
    SEVEN_ZIP_HOME="C:\Program Files\7-Zip" \
    MSYS2_URL=https://bintray.com/mabrarov/generic/download_file?file_path=msys2 \
    MSYS2_TARGET=x86_64 \
    MSYS2_VERSION=20161025 \
    MSYS_HOME=C:\\msys64 \
    ACTIVE_PERL_VERSION=5.26.3.2603 \
    ACTIVE_PERL_BUILD=a95bce075 \
    ACTIVE_PERL_URL=http://downloads.activestate.com/ActivePerl/releases \
    ACTIVE_PERL_HOME=C:\\Perl64

ADD ["app", "C:/app/"]

RUN mkdir C:\download && \
    mkdir C:\build && \
    mkdir C:\target && \
    powershell -ExecutionPolicy Bypass -File "C:\app\install.ps1" && \
    powershell "Remove-Item -Path 'C:\app' -Recurse -Force"
