#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

FROM abrarov/mingw:2.12.1

ENV OPENSSL_VERSION="1.0.2q" \
    ICU_VERSION="64.2" \
    QT_VERSION="5.15.2" \
    QT_URL="http://download.qt.io/official_releases/qt" \
    DEPEND_DIR="C:\depend" \
    MAKE_OPTIONS=""

ADD ["app", "C:/app/"]

RUN mkdir "%DEPEND_DIR%"

VOLUME ["C:/target", "C:/depend"]

CMD ["powershell", "-ExecutionPolicy", "Bypass", "-File", "C:\\app\\start.ps1"]

ARG image_version=""
ARG image_revision=""

LABEL name="abrarov/qt5-mingw" \
    version="${image_version}" \
    revision="${image_revision}" \
    description="Builder of Qt 5.x with MinGW"
