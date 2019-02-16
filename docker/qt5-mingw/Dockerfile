#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the Boost Software License, Version 1.0. (See accompanying
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
#

FROM abrarov/mingw:2.1.0

ARG image_version=""
ARG image_revision=""

LABEL name="abrarov/qt5-mingw" \
    version="${image_version}" \
    revision="${image_revision}" \
    description="Builder of Qt 5.x with MinGW"

ENV OPENSSL_VERSION=1.0.2q \
    QT_VERSION=5.12.1 \
    QT_URL=http://download.qt.io/official_releases/qt \
    SCRIPT_DIR=C:\\app \
    DEPEND_DIR=C:\\depend

ADD ["app", "C:/app/"]

RUN mkdir C:\depend

VOLUME ["C:/target", "C:/depend"]

ENTRYPOINT ["powershell"]

CMD ["C:/app/start.ps1"]
