#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

FROM abrarov/msvc-2017:2.17.0

ENV ICU_VERSION="64.2" \
    ICU_URL="https://github.com/unicode-org/icu/releases/download" \
    ICU_TEST=""

RUN set "PATH=%PYTHON3_HOME%;%PYTHON3_HOME%\Scripts;%PATH%" && \
    "%PYTHON3_HOME%\Scripts\pip" --disable-pip-version-check install buildtool && \
    powershell "Remove-Item -Path \"${env:TMP}\*\" -Recurse -Force"

ADD ["app", "C:/app/"]

VOLUME ["C:/target"]

CMD ["powershell", "-ExecutionPolicy", "Bypass", "-File", "C:\\app\\start.ps1"]

ARG image_version=""
ARG image_revision=""

LABEL name="abrarov/icu-msvc-2017" \
    version="${image_version}" \
    revision="${image_revision}" \
    description="Builder of ICU with Microsoft Visual C++ 2017"
