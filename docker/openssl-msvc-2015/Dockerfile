#
# Copyright (c) 2019 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

FROM abrarov/msvc-2015:2.3.0

ENV OPENSSL_VERSION=1.0.2q \
    OPENSSL_URL=https://www.openssl.org/source \
    OPENSSL_TEST="" \
    SCRIPT_DIR=C:\\app

ADD ["app", "C:/app/"]

VOLUME ["C:/target"]

CMD ["powershell", "-ExecutionPolicy", "Bypass", "-File", "C:\\app\\start.ps1"]

ARG image_version=""
ARG image_revision=""

LABEL name="abrarov/openssl-msvc-2015" \
    version="${image_version}" \
    revision="${image_revision}" \
    description="Builder of OpenSSL with Microsoft Visual C++ 2015"
