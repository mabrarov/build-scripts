@echo off

rem
rem Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
rem
rem Distributed under the MIT License (see accompanying LICENSE)
rem

set exit_code=0

set PATH=%MINGW_HOME%\bin;%MSYS_HOME%\usr\bin;%PATH%
exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

if not "--%OPENSSL_PATCH_MSYS_FILE%" == "--" (
  patch -uNf -i "%OPENSSL_PATCH_MSYS_FILE%"
  exit_code=%errorlevel%
  if %exit_code% neq 0 goto exit
)

if "%OPENSSL_LINKAGE%" == "shared" (
  perl Configure --prefix=%OPENSSL_STAGE_MSYS_DIR% %OPENSSL_TOOLSET% shared
  exit_code=%errorlevel%
  if %exit_code% neq 0 goto exit
) else (
  perl Configure --prefix=%OPENSSL_STAGE_MSYS_DIR% %OPENSSL_TOOLSET% enable-static-engine no-shared
  exit_code=%errorlevel%
  if %exit_code% neq 0 goto exit
)

make depend
exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

make
exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

make install
exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

:exit
exit /B %exit_code%