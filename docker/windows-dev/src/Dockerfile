#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

FROM mcr.microsoft.com/windows/servercore:ltsc2019

ENV DOWNLOAD_DIR="C:\download" \
    BUILD_DIR="C:\build" \
    TARGET_DIR="C:\target" \
    SEVEN_ZIP_VERSION="22.01" \
    SEVEN_ZIP_DOWNLOAD_URL="http://www.7-zip.org/a" \
    SEVEN_ZIP_HOME="C:\Program Files\7-Zip" \
    GIT_VERSION="2.37.2.2" \
    CMAKE_VERSION="3.24.1" \
    CMAKE_URL="https://github.com/Kitware/CMake/releases/download" \
    CMAKE_HOME="C:\cmake" \
    MSYS2_URL="http://repo.msys2.org/distrib" \
    MSYS2_TARGET="x86_64" \
    MSYS2_VERSION="20220603" \
    MSYS_HOME="C:\msys64" \
    ACTIVE_PERL_VERSION="5.28" \
    ACTIVE_PERL_URL="https://cli-msi.s3.amazonaws.com" \
    ACTIVE_PERL_HOME="C:\Perl" \
    PYTHON_URL="https://www.python.org/ftp/python" \
    PYTHON3_VERSION="3.10.6" \
    PYTHON3_HOME="C:\Python3" \
    PYTHON2_VERSION="2.7.18" \
    PYTHON2_HOME="C:\Python2" \
    NINJA_VERSION="1.10.2" \
    NINJA_URL="https://github.com/ninja-build/ninja/releases/download" \
    NINJA_HOME="C:\ninja"

ADD ["app", "C:/app/"]

RUN mkdir "%DOWNLOAD_DIR%" && \
    mkdir "%BUILD_DIR%" && \
    mkdir "%TARGET_DIR%" && \
    powershell -ExecutionPolicy Bypass -File "C:\app\install.ps1" && \
    powershell "Remove-Item -Path 'C:\app' -Recurse -Force"

ARG image_version=""
ARG image_revision=""

LABEL name="abrarov/windows-dev" \
    version="${image_version}" \
    revision="${image_revision}" \
    description="Base image for builders on Windows"
