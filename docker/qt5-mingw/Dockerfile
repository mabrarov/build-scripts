#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the Boost Software License, Version 1.0. (See accompanying
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
#

FROM abrarov/mingw:1.0.2

LABEL name="abrarov/qt5-mingw" \
    version="1.0.0" \
    description="Builder of Qt 5.x with MinGW"

ENV QT_VERSION=5.9.1 \
    QT_URL=http://download.qt.io/official_releases/qt \
    SCRIPT_DIR=C:\\app \
    DOWNLOAD_DIR=C:\\download \
    BUILD_DIR=C:\\build \
    TARGET_DIR=C:\\target \
    DEPEND_DIR=C:\\depend \
    ACTIVE_PERL_VERSION=5.24.1.2402 \
    ACTIVE_PERL_BUILD=401627 \
    ACTIVE_PERL_URL=http://downloads.activestate.com/ActivePerl/releases \
    PYTHON_VERSION=3.6.2 \
    PYTHON_URL=https://www.python.org/ftp/python \
    MSYS2_URL=https://bintray.com/mabrarov/generic/download_file?file_path=msys2 \
    MSYS2_TARGET=x86_64 \
    MSYS2_VERSION=20161025

ADD ["app", "C:/app/"]

RUN mkdir C:\download && \
    mkdir C:\build && \
    mkdir C:\target && \
    mkdir C:\depend  && \
    powershell "(New-Object System.Net.WebClient).DownloadFile(\"$env:ACTIVE_PERL_URL/$env:ACTIVE_PERL_VERSION/ActivePerl-$env:ACTIVE_PERL_VERSION-MSWin32-x64-$env:ACTIVE_PERL_BUILD.exe\", \"$env:TMP\ActivePerl.exe\")" && \
    powershell "Start-Process -FilePath \"$env:TMP\ActivePerl.exe\" -ArgumentList (\"/exenoui\", \"/norestart\", \"/quiet\", \"/qn\") -Wait" && \
    powershell "(New-Object System.Net.WebClient).DownloadFile(\"$env:PYTHON_URL/$env:PYTHON_VERSION/python-$env:PYTHON_VERSION-amd64.exe\", \"$env:TMP\Python.exe\")" && \
    powershell "Start-Process -FilePath \"$env:TMP\Python.exe\" -ArgumentList (\"/exenoui\", \"/norestart\", \"/quiet\", \"/qn\", \"InstallAllUsers=1\") -Wait" && \
    powershell "(New-Object System.Net.WebClient).DownloadFile(\"$env:MSYS2_URL%2F$env:MSYS2_VERSION%2F$env:MSYS2_TARGET%2Fmsys2-base-devel-$env:MSYS2_TARGET-$env:MSYS2_VERSION.7z\", \"$env:TMP\msys2.7z\")" && \
    "%ProgramFiles%\7-Zip\7z.exe" x "%TMP%\msys2.7z" -o"C:\" -aoa -y && \
    powershell "Remove-Item \"$env:TMP\*\" -Recurse -Force"

VOLUME ["C:/target", "C:/depend"]

ENTRYPOINT ["powershell"]

CMD ["C:/app/start.ps1"]
