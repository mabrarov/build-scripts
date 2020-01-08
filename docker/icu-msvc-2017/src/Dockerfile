#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

FROM abrarov/msvc-2017:2.8.0

ENV ICU_VERSION="64.2" \
    ICU_URL="http://download.icu-project.org/files/icu4c" \
    ICU_TEST=""

ADD ["app", "C:/app/"]

VOLUME ["C:/target"]

CMD ["powershell", "-ExecutionPolicy", "Bypass", "-File", "C:\\app\\start.ps1"]

ARG image_version=""
ARG image_revision=""

LABEL name="abrarov/icu-msvc-2017" \
    version="${image_version}" \
    revision="${image_revision}" \
    description="Builder of ICU with Microsoft Visual C++ 2017"
