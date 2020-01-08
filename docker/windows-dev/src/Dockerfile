#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

FROM mcr.microsoft.com/windows/servercore:ltsc2019

ENV DOWNLOAD_DIR="C:\download" \
    BUILD_DIR="C:\build" \
    TARGET_DIR="C:\target" \
    SEVEN_ZIP_VERSION="18.01" \
    SEVEN_ZIP_DOWNLOAD_URL="http://www.7-zip.org/a" \
    SEVEN_ZIP_HOME="C:\Program Files\7-Zip" \
    GIT_VERSION="2.24.1.2" \
    CMAKE_VERSION="3.16.2" \
    CMAKE_URL="https://github.com/Kitware/CMake/releases/download" \
    CMAKE_HOME="C:\cmake" \
    MSYS2_URL="http://repo.msys2.org/distrib" \
    MSYS2_TARGET="x86_64" \
    MSYS2_VERSION="20190524" \
    MSYS_HOME="C:\msys64" \
    ACTIVE_PERL_VERSION="5.26.3.2603" \
    ACTIVE_PERL_BUILD="a95bce075" \
    ACTIVE_PERL_URL="http://downloads.activestate.com/ActivePerl/releases" \
    ACTIVE_PERL_HOME="C:\Perl64" \
    PYTHON_URL="https://www.python.org/ftp/python" \
    PYTHON3_VERSION="3.8.1" \
    PYTHON3_HOME="C:\Python37" \
    PYTHON2_VERSION="2.7.17" \
    PYTHON2_HOME="C:\Python27"

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
