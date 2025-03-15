#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

FROM abrarov/mingw:2.17.0

ENV OPENSSL_VERSION="1.0.2q" \
    OPENSSL_URL="https://www.openssl.org/source" \
    OPENSSL_TEST=""

ADD ["app", "C:/app/"]

VOLUME ["C:/target"]

CMD ["powershell", "-ExecutionPolicy", "Bypass", "-File", "C:\\app\\start.ps1"]

ARG image_version=""
ARG image_revision=""

LABEL name="abrarov/openssl-mingw" \
    version="${image_version}" \
    revision="${image_revision}" \
    description="Builder of OpenSSL with MinGW"
