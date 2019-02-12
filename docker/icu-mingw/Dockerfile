#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the Boost Software License, Version 1.0. (See accompanying
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
#

FROM abrarov/mingw:2.0.0

ARG image_version=""
ARG image_revision=""

LABEL name="abrarov/icu-mingw" \
    version="${image_version}" \
    revision="${image_revision}" \
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
    powershell -ExecutionPolicy Bypass -File "C:\app\install.ps1" && \
    powershell "Remove-Item -Path 'C:\app\install.ps1' -Force"

VOLUME ["C:/target"]

ENTRYPOINT ["powershell"]

CMD ["C:/app/start.ps1"]
