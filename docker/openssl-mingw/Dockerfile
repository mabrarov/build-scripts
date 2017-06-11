#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the Boost Software License, Version 1.0. (See accompanying
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
#

FROM abrarov/mingw:1.0.0

ENV OPENSSL_VERSION=1.0.2l \
    OPENSSL_URL=https://www.openssl.org/source

LABEL name="abrarov/mingw-openssl" \
    version="1.0.0" \
    description="Builder of OpenSSL with MinGW"

ENV SCRIPT_DIR=C:\\app \
    DOWNLOAD_DIR=C:\\download \
    BUILD_DIR=C:\\build \
    TARGET_DIR=C:\\target \
    MSYS2_URL=http://repo.msys2.org/distrib \
    MSYS2_PLATFORM=x86_64 \
    MSYS2_VERSION=20161025

ADD ["app", "C:/app/"]

RUN mkdir C:\download && \
    mkdir C:\build && \
    mkdir C:\target && \
    powershell "(New-Object System.Net.WebClient).DownloadFile(\"$env:MSYS2_URL/$env:MSYS2_PLATFORM/msys2-base-$env:MSYS2_PLATFORM-$env:MSYS2_VERSION.tar.xz\", \"C:\download\msys2-base-$env:MSYS2_PLATFORM-$env:MSYS2_VERSION.tar.xz\")" && \
    "%ProgramFiles%\7-Zip\7z.exe" x "C:\download\msys2-base-%MSYS2_PLATFORM%-%MSYS2_VERSION%.tar.xz" -o"%TMP%" -aoa -y > nul && \
    "%ProgramFiles%\7-Zip\7z.exe" x "%TMP%\msys2-base-%MSYS2_PLATFORM%-%MSYS2_VERSION%.tar" -o"C:\"  -aoa -y > nul && \
    "C:\msys64\usr\bin\bash.exe" --login -c exit > nul && \
    "C:\msys64\usr\bin\bash.exe" --login -c 'pacman --noconfirm -Syuu' > nul && \
    "C:\msys64\usr\bin\bash.exe" --login -c 'pacman --noconfirm -Syuu' > nul && \
    "C:\msys64\usr\bin\bash.exe" --login -c 'pacman --noconfirm -S base-devel perl' > nul

VOLUME ["C:/target"]

ENTRYPOINT ["powershell"]

CMD ["C:/app/start.ps1"]
