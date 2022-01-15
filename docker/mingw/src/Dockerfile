#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

FROM abrarov/windows-dev:2.14.0

ENV MINGW_VERSION="8.1.0" \
    MINGW_RT_FILE_SUFFIX="6" \
    MINGW_REVISON="0" \
    MINGW_URL="https://sourceforge.net/projects/mingw-w64/files" \
    MINGW_URL_POSTFIX="/download" \
    MINGW_64_TOOLCHAIN_PATH="Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds" \
    MINGW_64_TARGET="x86_64" \
    MINGW_64_THREADS="posix" \
    MINGW_64_EXCEPTIONS="seh" \
    MINGW_32_TOOLCHAIN_PATH="Toolchains%20targetting%20Win32/Personal%20Builds/mingw-builds" \
    MINGW_32_TARGET="i686" \
    MINGW_32_THREADS="posix" \
    MINGW_32_EXCEPTIONS="dwarf" \
    MINGW64_HOME="C:\mingw64" \
    MINGW32_HOME="C:\mingw32"

ADD ["app", "C:/app/"]

RUN powershell -ExecutionPolicy Bypass -File "C:\app\install.ps1" && \
    powershell "Remove-Item -Path 'C:\app' -Recurse -Force"

ARG image_version=""
ARG image_revision=""

LABEL name="abrarov/mingw" \
    version="${image_version}" \
    revision="${image_revision}" \
    description="MinGW-w64 from MinGW-builds"
