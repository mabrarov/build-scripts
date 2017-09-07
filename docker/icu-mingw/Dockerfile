#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the Boost Software License, Version 1.0. (See accompanying
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
#

FROM abrarov/mingw:1.0.2

LABEL name="abrarov/icu-mingw" \
    version="1.0.2" \
    description="Builder of ICU with MinGW"

ENV ICU_VERSION=57.1 \
    ICU_URL=http://download.icu-project.org/files/icu4c \
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
    powershell "(New-Object System.Net.WebClient).DownloadFile(\"$env:MSYS2_URL%2F$env:MSYS2_VERSION%2F$env:MSYS2_TARGET%2Fmsys2-base-devel-$env:MSYS2_TARGET-$env:MSYS2_VERSION.7z\", \"$env:TMP\msys2.7z\")" && \
    "%ProgramFiles%\7-Zip\7z.exe" x "%TMP%\msys2.7z" -o"C:\" -aoa -y && \
    powershell "Remove-Item \"$env:TMP\*\" -Recurse -Force"

VOLUME ["C:/target"]

ENTRYPOINT ["powershell"]

CMD ["C:/app/start.ps1"]
