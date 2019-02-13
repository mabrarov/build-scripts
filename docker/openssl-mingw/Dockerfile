#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

FROM abrarov/mingw:2.0.0

ARG image_version=""
ARG image_revision=""

LABEL name="abrarov/openssl-mingw" \
    version="${image_version}" \
    revision="${image_revision}" \
    description="Builder of OpenSSL with MinGW"

ENV OPENSSL_VERSION=1.0.2q \
    OPENSSL_URL=https://www.openssl.org/source \
    SCRIPT_DIR=C:\\app

ADD ["app", "C:/app/"]

VOLUME ["C:/target"]

ENTRYPOINT ["powershell"]

CMD ["C:/app/start.ps1"]
