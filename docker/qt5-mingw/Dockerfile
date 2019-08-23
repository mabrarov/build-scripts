#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

FROM abrarov/mingw:2.4.0

ENV OPENSSL_VERSION=1.0.2q \
    ICU_VERSION=64.2 \
    QT_VERSION=5.13.0 \
    QT_URL=http://download.qt.io/official_releases/qt \
    SCRIPT_DIR=C:\\app \
    DEPEND_DIR=C:\\depend \
    MAKE_OPTIONS=""

ADD ["app", "C:/app/"]

RUN mkdir C:\depend

VOLUME ["C:/target", "C:/depend"]

CMD ["powershell", "-ExecutionPolicy", "Bypass", "-File", "C:\\app\\start.ps1"]

ARG image_version=""
ARG image_revision=""

LABEL name="abrarov/qt5-mingw" \
    version="${image_version}" \
    revision="${image_revision}" \
    description="Builder of Qt 5.x with MinGW"
