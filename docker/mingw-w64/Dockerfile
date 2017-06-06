#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the Boost Software License, Version 1.0. (See accompanying
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
#

FROM microsoft/windowsservercore:10.0.14393.1198

ENV MINGW_VERSION=7.1.0 \
    MINGW_RT_FILE_SUFFIX=5 \
    MINGW_REVISON=0 \
    MINGW_RELEASE_URL=https://bintray.com/mabrarov/generic/download_file?file_path=MinGW \
    MINGW_64_PLATFORM=x64 \
    MINGW_64_TARGET=x86_64 \
    MINGW_64_THREADS=threads-posix \
    MINGW_64_THREADS_FILE_SUFFIX=posix \
    MINGW_64_EXCEPTIONS=seh \
    MINGW_32_PLATFORM=x86 \
    MINGW_32_TARGET=i686 \
    MINGW_32_THREADS=threads-posix \
    MINGW_32_THREADS_FILE_SUFFIX=posix \
    MINGW_32_EXCEPTIONS=dwarf \
    SEVEN_ZIP_VERSION=1604 \
    SEVEN_ZIP_DOWNLOAD_URL=http://www.7-zip.org/a

LABEL name="abrarov/mingw-w64" \
    version="1.0.0" \
    description="MinGW-w64 from MinGW-builds"

RUN powershell "Invoke-WebRequest -Uri \"$env:SEVEN_ZIP_DOWNLOAD_URL/7z$env:SEVEN_ZIP_VERSION-x64.msi\" -OutFile \"$env:TMP\7z.msi\"" && \
    powershell "Start-Process -FilePath msiexec -ArgumentList (\"/package\", \"$env:TMP\7z.msi\", \"/quiet\", \"/qn\", \"/norestart\") -Wait" && \
    del /F /Q "%TMP%\7z.msi" && \
    powershell "Invoke-WebRequest -Uri \"$env:MINGW_RELEASE_URL%2F$env:MINGW_64_PLATFORM%2F$env:MINGW_VERSION-rev$env:MINGW_REVISON%2F$env:MINGW_64_EXCEPTIONS%2F$env:MINGW_64_THREADS%2F$env:MINGW_64_TARGET-$env:MINGW_VERSION-release-$env:MINGW_64_THREADS_FILE_SUFFIX-$env:MINGW_64_EXCEPTIONS-rt_v$env:MINGW_RT_FILE_SUFFIX-rev$env:MINGW_REVISON.7z\" -OutFile \"$env:TMP\mingw.7z\"" && \
    "%ProgramFiles%\7-Zip\7z.exe" x "%TMP%\mingw.7z" -o"%ProgramFiles%" -aoa -y && \
    del /F /Q "%TMP%\mingw.7z" && \
    powershell "Invoke-WebRequest -Uri \"$env:MINGW_RELEASE_URL%2F$env:MINGW_32_PLATFORM%2F$env:MINGW_VERSION-rev$env:MINGW_REVISON%2F$env:MINGW_32_EXCEPTIONS%2F$env:MINGW_32_THREADS%2F$env:MINGW_32_TARGET-$env:MINGW_VERSION-release-$env:MINGW_32_THREADS_FILE_SUFFIX-$env:MINGW_32_EXCEPTIONS-rt_v$env:MINGW_RT_FILE_SUFFIX-rev$env:MINGW_REVISON.7z\" -OutFile \"$env:TMP\mingw.7z\"" && \
    "%ProgramFiles%\7-Zip\7z.exe" x "%TMP%\mingw.7z" -o"%ProgramFiles(x86)%" -aoa -y && \
    del /F /Q "%TMP%\mingw.7z"
