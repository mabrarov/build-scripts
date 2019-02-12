@echo off

rem
rem Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
rem
rem Distributed under the MIT License (see accompanying LICENSE)
rem

set PATH=%MINGW_HOME%\bin;%PATH%
if errorlevel 1 goto exit

if "%OPENSSL_LINKAGE%" == "shared" (
  perl Configure --prefix=%OPENSSL_STAGE_MSYS_DIR% %OPENSSL_TOOLSET% shared
) else (
  perl Configure --prefix=%OPENSSL_STAGE_MSYS_DIR% %OPENSSL_TOOLSET% enable-static-engine no-shared
)
if errorlevel 1 goto exit

make depend
if errorlevel 1 goto exit

make
if errorlevel 1 goto exit

make install

:exit