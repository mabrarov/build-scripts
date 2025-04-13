#
# Copyright (c) 2024 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

FROM abrarov/windows-dev:2.17.0

ENV MINGW_VERSION="14.2.0" \
    MINGW_RT_FILE_SUFFIX="12" \
    MINGW_REVISON="2" \
    MINGW_URL="https://github.com/niXman/mingw-builds-binaries/releases/download" \
    MINGW_64_TARGET="x86_64" \
    MINGW_64_THREADS="posix" \
    MINGW_64_EXCEPTIONS="seh" \
    MINGW_64_MSVCRT="msvcrt" \
    MINGW_32_TARGET="i686" \
    MINGW_32_THREADS="posix" \
    MINGW_32_EXCEPTIONS="dwarf" \
    MINGW_32_MSVCRT="msvcrt" \
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
    description="MinGW-w64 14"
