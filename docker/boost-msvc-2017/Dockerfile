#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the Boost Software License, Version 1.0. (See accompanying
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
#

FROM abrarov/msvc-2017:1.0.0

ENV BOOST_VERSION=1.64.0 \
    BOOST_RELEASE_URL=https://dl.bintray.com/boostorg/release

LABEL name="abrarov/boost-msvc-2017" \
    version="1.0.0" \
    description="Builder of Boost C++ Libraries with Microsoft Visual C++ 2017"

ENV SCRIPT_DIR=C:\\app \
    DOWNLOAD_DIR=C:\\download \
    BUILD_DIR=C:\\build \
    TARGET_DIR=C:\\target

ADD ["app", "C:/app/"]

RUN mkdir C:\download && \
    mkdir C:\build && \
    mkdir C:\target

VOLUME ["C:/target"]

ENTRYPOINT ["powershell"]

CMD ["C:/app/start.ps1"]
