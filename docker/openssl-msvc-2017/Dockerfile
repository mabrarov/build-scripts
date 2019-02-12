#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

FROM abrarov/msvc-2017:1.0.2

LABEL name="abrarov/openssl-msvc-2017" \
    version="1.0.1" \
    description="Builder of OpenSSL with Microsoft Visual C++ 2017"

ENV OPENSSL_VERSION=1.0.2l \
    OPENSSL_URL=https://www.openssl.org/source \
    SCRIPT_DIR=C:\\app \
    DOWNLOAD_DIR=C:\\download \
    BUILD_DIR=C:\\build \
    TARGET_DIR=C:\\target \
    ACTIVE_PERL_VERSION=5.24.1.2402 \
    ACTIVE_PERL_BUILD=401627 \
    ACTIVE_PERL_URL=http://downloads.activestate.com/ActivePerl/releases \
    SEVEN_ZIP_VERSION=1604 \
    SEVEN_ZIP_DOWNLOAD_URL=http://www.7-zip.org/a

ADD ["app", "C:/app/"]

RUN mkdir C:\download && \
    mkdir C:\build && \
    mkdir C:\target && \
    powershell "(New-Object System.Net.WebClient).DownloadFile(\"$env:ACTIVE_PERL_URL/$env:ACTIVE_PERL_VERSION/ActivePerl-$env:ACTIVE_PERL_VERSION-MSWin32-x64-$env:ACTIVE_PERL_BUILD.exe\", \"$env:TMP\ActivePerl.exe\")" && \
    powershell "Start-Process -FilePath \"$env:TMP\ActivePerl.exe\" -ArgumentList (\"/exenoui\", \"/norestart\", \"/quiet\", \"/qn\") -Wait" && \
    powershell "(New-Object System.Net.WebClient).DownloadFile(\"$env:SEVEN_ZIP_DOWNLOAD_URL/7z$env:SEVEN_ZIP_VERSION-x64.msi\", \"$env:TMP\7z$env:SEVEN_ZIP_VERSION-x64.msi\")" && \
    powershell "Start-Process -FilePath msiexec -ArgumentList (\"/package\", \"$env:TMP\7z$env:SEVEN_ZIP_VERSION-x64.msi\", \"/quiet\", \"/qn\", \"/norestart\") -Wait" && \
    powershell "Remove-Item -Path \"$env:TMP\*\" -Recurse -Force"

VOLUME ["C:/target"]

ENTRYPOINT ["powershell"]

CMD ["C:/app/start.ps1"]
