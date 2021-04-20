#
# Copyright (c) 2020 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

FROM ubuntu:20.04

ENV TZ="Europe/Moscow" \
    DOWNLOAD_DIR="/download" \
    BUILD_DIR="/build" \
    TARGET_DIR="/target"

RUN ln -snf "/usr/share/zoneinfo/${TZ}" /etc/localtime && \
    echo "${TZ}" > /etc/timezone && \
    apt-get update && \
    apt-get install -y \
      curl \
      tar \
      gzip \
      git \
      g++ \
      make \
      libstdc++-9-dev \
      libicu-dev \
      python-dev \
      libzip-dev \
      libbz2-dev \
      lzma-dev \
      libz-dev && \
    mkdir -p "${DOWNLOAD_DIR}" && \
    mkdir -p "${BUILD_DIR}" && \
    mkdir -p "${TARGET_DIR}"

ADD ["app", "/app"]

VOLUME ["/target"]

CMD ["/app/start.sh"]

ENV BOOST_VERSION="1.76.0" \
    BOOST_RELEASE_URL="https://dl.bintray.com/boostorg/release" \
    B2_OPTIONS="--without-mpi --without-graph_parallel"

ARG image_version=""
ARG image_revision=""

LABEL name="abrarov/boost-ubuntu-gcc" \
    version="${image_version}" \
    revision="${image_revision}" \
    description="Builder of Boost C++ Libraries with Ubuntu and GCC"
