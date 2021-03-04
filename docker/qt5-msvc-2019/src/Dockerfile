#
# Copyright (c) 2021 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

FROM abrarov/msvc-2019:2.11.0

ENV LLVM_VERSION="11.1.0" \
    LLVM_URL="https://github.com/llvm/llvm-project/releases/download" \
    LLVM_DIST_NAME="LLVM-11.1.0-win64.exe" \
    LLVM_INSTALL_DIR="C:\Program Files\LLVM" \
    JOM_HOME="C:\jom" \
    JOM_URL="http://master.qt.io/official_releases/jom" \
    JOM_VERSION="1.1.3" \
    DEPEND_DIR="C:\depend"

ADD ["app", "C:/app/"]

RUN mkdir "%DEPEND_DIR%" && \
    powershell -ExecutionPolicy Bypass -File "C:\app\install.ps1" && \
    powershell "Remove-Item -Path 'C:\app\install.ps1' -Recurse -Force"

ENV OPENSSL_VERSION="1.0.2q" \
    ICU_VERSION="64.2" \
    QT_VERSION="5.15.2" \
    QT_URL="http://download.qt.io/official_releases/qt" \
    JOM_OPTIONS=""

VOLUME ["C:/target", "C:/depend"]

CMD ["powershell", "-ExecutionPolicy", "Bypass", "-File", "C:\\app\\start.ps1"]

ARG image_version=""
ARG image_revision=""

LABEL name="abrarov/qt5-msvc-2019" \
    version="${image_version}" \
    revision="${image_revision}" \
    description="Builder of Qt 5.x with MinGW"
