#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

FROM abrarov/mingw:2.14.0

ENV ICU_VERSION="70.1" \
    ICU_URL="https://github.com/unicode-org/icu/releases/download" \
    ICU_TEST=""

ADD ["app", "C:/app/"]

VOLUME ["C:/target"]

CMD ["powershell", "-ExecutionPolicy", "Bypass", "-File", "C:\\app\\start.ps1"]

ARG image_version=""
ARG image_revision=""

LABEL name="abrarov/icu-mingw" \
    version="${image_version}" \
    revision="${image_revision}" \
    description="Builder of ICU with MinGW"
