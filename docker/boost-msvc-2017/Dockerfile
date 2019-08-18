#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

FROM abrarov/msvc-2017:2.2.0

ENV BOOST_VERSION=1.69.0 \
    BOOST_RELEASE_URL=https://dl.bintray.com/boostorg/release \
    SCRIPT_DIR=C:\\app

ADD ["app", "C:/app/"]

VOLUME ["C:/target"]

ENTRYPOINT ["powershell"]

CMD ["C:/app/start.ps1"]

ARG image_version=""
ARG image_revision=""

LABEL name="abrarov/boost-mingw" \
    version="${image_version}" \
    revision="${image_revision}" \
    description="Builder of Boost C++ Libraries with MS Visual C++ 2017"
