#
# Copyright (c) 2022 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

FROM abrarov/msvc-2022:2.15.0

ENV BOOST_VERSION="1.80.0" \
    BOOST_RELEASE_URL="https://boostorg.jfrog.io/artifactory/main/release" \
    B2_OPTIONS="--without-python --without-mpi --without-graph_parallel"

ADD ["app", "C:/app/"]

VOLUME ["C:/target"]

CMD ["powershell", "-ExecutionPolicy", "Bypass", "-File", "C:\\app\\start.ps1"]

ARG image_version=""
ARG image_revision=""

LABEL name="abrarov/boost-msvc-2022" \
    version="${image_version}" \
    revision="${image_revision}" \
    description="Builder of Boost C++ Libraries with MS Visual C++ 2022"
