#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

FROM abrarov/win-builder:1.0.0

LABEL name="abrarov/mingw" \
    version="1.0.3" \
    description="MinGW-w64 from MinGW-builds"

ENV MINGW_VERSION=8.1.0 \
    MINGW_RT_FILE_SUFFIX=6 \
    MINGW_REVISON=0 \
    MINGW_RELEASE_URL=https://sourceforge.net/projects/mingw-w64/files \
    MINGW_URL_POSTFIX=.7z/download \
    MINGW_64_TOOLCHAIN_PATH=Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds \
    MINGW_64_TARGET=x86_64 \
    MINGW_64_THREADS=posix \
    MINGW_64_EXCEPTIONS=seh \
    MINGW_32_TOOLCHAIN_PATH=Toolchains%20targetting%20Win32/Personal%20Builds/mingw-builds \
    MINGW_32_TARGET=i686 \
    MINGW_32_THREADS=posix \
    MINGW_32_EXCEPTIONS=dwarf

ADD ["app", "C:/app/"]

RUN powershell -ExecutionPolicy Bypass -File "C:\app\install.ps1" && \
    powershell "Remove-Item -Path 'C:\app' -Recurse -Force"
