#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

FROM abrarov/msvc-2017:1.0.2

LABEL name="abrarov/icu-msvc-2017" \
    version="1.0.2" \
    description="Builder of ICU with Microsoft Visual C++ 2017"

ENV ICU_VERSION=57.1 \
    ICU_URL=http://download.icu-project.org/files/icu4c \
    SCRIPT_DIR=C:\\app \
    DOWNLOAD_DIR=C:\\download \
    BUILD_DIR=C:\\build \
    TARGET_DIR=C:\\target \
    SEVEN_ZIP_VERSION=1604 \
    SEVEN_ZIP_DOWNLOAD_URL=http://www.7-zip.org/a \
    MSYS2_URL=https://bintray.com/mabrarov/generic/download_file?file_path=msys2 \
    MSYS2_TARGET=x86_64 \
    MSYS2_VERSION=20161025

ADD ["app", "C:/app/"]

RUN mkdir C:\download && \
    mkdir C:\build && \
    mkdir C:\target && \
    powershell "(New-Object System.Net.WebClient).DownloadFile(\"$env:SEVEN_ZIP_DOWNLOAD_URL/7z$env:SEVEN_ZIP_VERSION-x64.msi\", \"$env:TMP\7z$env:SEVEN_ZIP_VERSION-x64.msi\")" && \
    powershell "Start-Process -FilePath msiexec -ArgumentList (\"/package\", \"$env:TMP\7z$env:SEVEN_ZIP_VERSION-x64.msi\", \"/quiet\", \"/qn\", \"/norestart\") -Wait" && \
    powershell "(New-Object System.Net.WebClient).DownloadFile(\"$env:MSYS2_URL%2F$env:MSYS2_VERSION%2F$env:MSYS2_TARGET%2Fmsys2-base-devel-$env:MSYS2_TARGET-$env:MSYS2_VERSION.7z\", \"$env:TMP\msys2.7z\")" && \
    "%ProgramFiles%\7-Zip\7z.exe" x "%TMP%\msys2.7z" -o"C:\" -aoa -y && \
    powershell "Remove-Item \"$env:TMP\*\" -Recurse -Force"

VOLUME ["C:/target"]

ENTRYPOINT ["powershell"]

CMD ["C:/app/start.ps1"]
