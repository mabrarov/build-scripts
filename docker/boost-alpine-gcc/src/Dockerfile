#
# Copyright (c) 2020 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

FROM alpine:3.13.5

ENV DOWNLOAD_DIR="/download" \
    BUILD_DIR="/build" \
    TARGET_DIR="/target"

RUN apk add --no-cache \
      bash \
      curl \
      tar \
      gzip \
      git \
      g++ \
      make \
      libstdc++ \
      linux-headers \
      icu-dev \
      python2-dev \
      libzip-dev \
      libbz2 && \
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

LABEL name="abrarov/boost-alpine-gcc" \
    version="${image_version}" \
    revision="${image_revision}" \
    description="Builder of Boost C++ Libraries with Ubuntu and GCC"
