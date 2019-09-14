#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

FROM abrarov/msvc-2017:2.6.0

ENV LLVM_VERSION="8.0.1" \
    LLVM_URL="https://github.com/llvm/llvm-project/releases/download" \
    LLVM_DIST_NAME="LLVM-8.0.1-win64.exe" \
    LLVM_INSTALL_DIR="C:\Program Files\LLVM" \
    JOM_HOME="C:\jom" \
    OPENSSL_VERSION="1.0.2q" \
    ICU_VERSION="64.2" \
    QT_VERSION="5.13.0" \
    QT_URL="http://download.qt.io/official_releases/qt" \
    JOM_URL="http://master.qt.io/official_releases/jom" \
    JOM_VERSION="1.1.3" \
    NINJA_SYNTAX_VERSION="1.7.2" \
    DEPEND_DIR="C:\depend" \
    JOM_OPTIONS=""

ADD ["app", "C:/app/"]

RUN mkdir "%DEPEND_DIR%" && \
    powershell -ExecutionPolicy Bypass -File "C:\app\install.ps1" && \
    powershell "Remove-Item -Path 'C:\app\install.ps1' -Recurse -Force"

VOLUME ["C:/target", "C:/depend"]

CMD ["powershell", "-ExecutionPolicy", "Bypass", "-File", "C:\\app\\start.ps1"]

ARG image_version=""
ARG image_revision=""

LABEL name="abrarov/qt5-msvc-2017" \
    version="${image_version}" \
    revision="${image_revision}" \
    description="Builder of Qt 5.x with MinGW"
