#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the Boost Software License, Version 1.0. (See accompanying
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
#

FROM abrarov/mingw:1.0.0

ENV OPENSSL_VERSION=1.0.2l \
    OPENSSL_URL=https://www.openssl.org/source \
    ACTIVE_PERL_VERSION=5.24.1.2402 \
    ACTIVE_PERL_BUILD=401627 \
    ACTIVE_PERL_URL=http://downloads.activestate.com/ActivePerl/releases

LABEL name="abrarov/mingw-openssl" \
    version="1.0.0" \
    description="Builder of OpenSSL with MinGW"

ENV SCRIPT_DIR=C:\\app \
    DOWNLOAD_DIR=C:\\download \
    BUILD_DIR=C:\\build \
    TARGET_DIR=C:\\target

ADD ["app", "C:/app/"]

RUN mkdir C:\download && \
    mkdir C:\build && \
    mkdir C:\target && \
    powershell "Invoke-WebRequest -Uri \"$env:ACTIVE_PERL_URL/$env:ACTIVE_PERL_VERSION/ActivePerl-$env:ACTIVE_PERL_VERSION-MSWin32-x64-$env:ACTIVE_PERL_BUILD.exe\" -OutFile \"$env:TMP\ActivePerl.exe\"" && \
    powershell "Start-Process -FilePath \"$env:TMP\ActivePerl.exe\" -ArgumentList (\"/exenoui\", \"/norestart\", \"/quiet\", \"/qn\") -Wait" && \
    del /F /Q "%TMP%\ActivePerl.exe" && \
    rd /q /s "%TMP%" && \
    mkdir "%TMP%"

VOLUME ["C:/target"]

ENTRYPOINT ["powershell"]

CMD ["C:/app/start.ps1"]
