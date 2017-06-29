#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the Boost Software License, Version 1.0. (See accompanying
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
#

FROM microsoft/windowsservercore:10.0.14393.1198

LABEL name="abrarov/mingw" \
    version="1.0.2" \
    description="MinGW-w64 from MinGW-builds"

ENV MINGW_VERSION=7.1.0 \
    MINGW_RT_FILE_SUFFIX=5 \
    MINGW_REVISON=0 \
    MINGW_RELEASE_URL=https://sourceforge.net/projects/mingw-w64/files \
    MINGW_URL_POSTFIX=.7z/download \
    MINGW_64_TOOLCHAIN_PATH=Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds \
    MINGW_64_TARGET=x86_64 \
    MINGW_64_THREADS=posix \
    MINGW_64_EXCEPTIONS=seh \
    MINGW_32_TOOLCHAIN_PATH=Toolchains%20targetting%20Win32/Personal%20Builds/mingw-builds \
    MINGW_32_TARGET=i686 \
    MINGW_32_THREADS=posix \
    MINGW_32_EXCEPTIONS=dwarf \
    SEVEN_ZIP_VERSION=1604 \
    SEVEN_ZIP_DOWNLOAD_URL=http://www.7-zip.org/a

RUN powershell "(New-Object System.Net.WebClient).DownloadFile(\"$env:SEVEN_ZIP_DOWNLOAD_URL/7z$env:SEVEN_ZIP_VERSION-x64.msi\", \"$env:TMP\7z$env:SEVEN_ZIP_VERSION-x64.msi\")" && \
    powershell "Start-Process -FilePath msiexec -ArgumentList (\"/package\", \"$env:TMP\7z$env:SEVEN_ZIP_VERSION-x64.msi\", \"/quiet\", \"/qn\", \"/norestart\") -Wait" && \
    powershell "(New-Object System.Net.WebClient).DownloadFile(\"$env:MINGW_RELEASE_URL/$env:MINGW_64_TOOLCHAIN_PATH/$env:MINGW_VERSION/threads-$env:MINGW_64_THREADS/$env:MINGW_64_EXCEPTIONS/$env:MINGW_64_TARGET-$env:MINGW_VERSION-release-$env:MINGW_64_THREADS-$env:MINGW_64_EXCEPTIONS-rt_v$env:MINGW_RT_FILE_SUFFIX-rev$env:MINGW_REVISON$env:MINGW_URL_POSTFIX\", \"$env:TMP\mingw.7z\")" && \
    "%ProgramFiles%\7-Zip\7z.exe" x "%TMP%\mingw.7z" -o"C:\" -aoa -y && \
    powershell "Remove-Item -Path \"$env:TMP\*\" -Recurse -Force"  && \
    powershell "(New-Object System.Net.WebClient).DownloadFile(\"$env:MINGW_RELEASE_URL/$env:MINGW_32_TOOLCHAIN_PATH/$env:MINGW_VERSION/threads-$env:MINGW_32_THREADS/$env:MINGW_32_EXCEPTIONS/$env:MINGW_32_TARGET-$env:MINGW_VERSION-release-$env:MINGW_32_THREADS-$env:MINGW_32_EXCEPTIONS-rt_v$env:MINGW_RT_FILE_SUFFIX-rev$env:MINGW_REVISON$env:MINGW_URL_POSTFIX\", \"$env:TMP\mingw.7z\")" && \
    "%ProgramFiles%\7-Zip\7z.exe" x "%TMP%\mingw.7z" -o"C:\" -aoa -y && \
    powershell "Remove-Item -Path \"$env:TMP\*\" -Recurse -Force"
