#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

FROM abrarov/msvc-2017:2.3.0

ENV JOM_HOME=C:\\jom \
    OPENSSL_VERSION=1.0.2q \
    ICU_VERSION=58.2 \
    QT_VERSION=5.13.0 \
    QT_URL=http://download.qt.io/official_releases/qt \
    JOM_URL=http://master.qt.io/official_releases/jom \
    JOM_VERSION=1.1.3 \
    SCRIPT_DIR=C:\\app \
    DEPEND_DIR=C:\\depend \
    JOM_OPTIONS=""

ADD ["app", "C:/app/"]

RUN mkdir C:\depend && \
    powershell -ExecutionPolicy Bypass -File "C:\app\install.ps1" && \
    powershell "Remove-Item -Path 'C:\app\install.ps1' -Recurse -Force"

VOLUME ["C:/target", "C:/depend"]

ENTRYPOINT ["powershell"]

CMD ["C:/app/start.ps1"]

ARG image_version=""
ARG image_revision=""

LABEL name="abrarov/qt5-msvc-2017" \
    version="${image_version}" \
    revision="${image_revision}" \
    description="Builder of Qt 5.x with MinGW"
