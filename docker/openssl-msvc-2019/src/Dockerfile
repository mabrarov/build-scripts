#
# Copyright (c) 2019 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

FROM abrarov/msvc-2019:2.18.0

ENV OPENSSL_VERSION="3.5.0" \
    OPENSSL_URL="https://github.com/openssl/openssl/releases/download" \
    OPENSSL_TEST=""

ADD ["app", "C:/app/"]

CMD ["powershell", "-ExecutionPolicy", "Bypass", "-File", "C:\\app\\start.ps1"]

ARG image_version=""
ARG image_revision=""

LABEL name="abrarov/openssl-msvc-2019" \
    version="${image_version}" \
    revision="${image_revision}" \
    description="Builder of OpenSSL with Microsoft Visual C++ 2019"
