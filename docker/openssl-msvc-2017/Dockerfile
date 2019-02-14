#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

FROM abrarov/msvc-2017:2.1.0

ARG image_version=""
ARG image_revision=""

LABEL name="abrarov/openssl-msvc-2017" \
    version="${image_version}" \
    revision="${image_revision}" \
    description="Builder of OpenSSL with Microsoft Visual C++ 2017"

ENV OPENSSL_VERSION=1.0.2q \
    OPENSSL_URL=https://www.openssl.org/source \
    SCRIPT_DIR=C:\\app

ADD ["app", "C:/app/"]

VOLUME ["C:/target"]

ENTRYPOINT ["powershell"]

CMD ["C:/app/start.ps1"]
