#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

FROM abrarov/mingw:2.0.0

ARG image_version=""
ARG image_revision=""

LABEL name="abrarov/openssl-mingw" \
    version="${image_version}" \
    revision="${image_revision}" \
    description="Builder of OpenSSL with MinGW"

ENV OPENSSL_VERSION=1.0.2l \
    OPENSSL_URL=https://www.openssl.org/source \
    SCRIPT_DIR=C:\\app \
    DOWNLOAD_DIR=C:\\download \
    BUILD_DIR=C:\\build \
    TARGET_DIR=C:\\target \
    MSYS2_URL=https://bintray.com/mabrarov/generic/download_file?file_path=msys2 \
    MSYS2_TARGET=x86_64 \
    MSYS2_VERSION=20161025

ADD ["app", "C:/app/"]

RUN mkdir C:\download && \
    mkdir C:\build && \
    mkdir C:\target && \
    powershell "(New-Object System.Net.WebClient).DownloadFile(\"${env:MSYS2_URL}%2F${env:MSYS2_VERSION}%2F${env:MSYS2_TARGET}%2Fmsys2-base-devel-${env:MSYS2_TARGET}-${env:MSYS2_VERSION}.7z\", \"${env:TMP}\msys2.7z\")" && \
    "%ProgramFiles%\7-Zip\7z.exe" x "%TMP%\msys2.7z" -o"C:\" -aoa -y && \
    powershell "Remove-Item -Path \"${env:TMP}\*\" -Recurse -Force"

VOLUME ["C:/target"]

ENTRYPOINT ["powershell"]

CMD ["C:/app/start.ps1"]
