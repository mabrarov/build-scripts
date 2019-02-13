@echo off

rem
rem Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
rem
rem Distributed under the MIT License (see accompanying LICENSE)
rem

set exit_code=0

call "%MSVC_BUILD_DIR%\%MSVC_CMD_BOOTSTRAP%"
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

set PATH=%PATH%;%MSYS_HOME%\usr\bin
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

if not "--%OPENSSL_PATCH_MSYS_FILE%" == "--" (
  patch -uNf -i "%OPENSSL_PATCH_MSYS_FILE%"
  exit_code=%errorlevel%
  if %exit_code% neq 0 goto exit
)

if "%OPENSSL_LINKAGE%" == "shared" (
  perl Configure --prefix=%OPENSSL_STAGE_DIR% %OPENSSL_TOOLSET% no-asm
  exit_code=%errorlevel%
  if %exit_code% neq 0 goto exit
) else (
  perl Configure --prefix=%OPENSSL_STAGE_DIR% %OPENSSL_TOOLSET% enable-static-engine no-asm no-shared
  exit_code=%errorlevel%
  if %exit_code% neq 0 goto exit
)

call "%OPENSSL_HOME%\ms\%OPENSSL_BOOTSTRAP%"
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

nmake -f "%OPENSSL_HOME%\ms\%OPENSSL_MAKE_FILE%" install
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

:exit
exit /B %exit_code%