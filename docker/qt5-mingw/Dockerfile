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
    DEPEND_DIR=C:\\depend \
    PYTHON_VERSION=3.6.2 \
    PYTHON_URL=https://www.python.org/ftp/python

ADD ["app", "C:/app/"]

RUN mkdir C:\download && \
    mkdir C:\build && \
    mkdir C:\target && \
    mkdir C:\depend  && \
    powershell "(New-Object System.Net.WebClient).DownloadFile(\"$env:PYTHON_URL/$env:PYTHON_VERSION/python-$env:PYTHON_VERSION-amd64.exe\", \"$env:TMP\Python.exe\")" && \
    powershell "Start-Process -FilePath \"$env:TMP\Python.exe\" -ArgumentList (\"/exenoui\", \"/norestart\", \"/quiet\", \"/qn\", \"InstallAllUsers=1\") -Wait" && \
    powershell "Remove-Item \"$env:TMP\*\" -Recurse -Force"

VOLUME ["C:/target", "C:/depend"]

ENTRYPOINT ["powershell"]

CMD ["C:/app/start.ps1"]
