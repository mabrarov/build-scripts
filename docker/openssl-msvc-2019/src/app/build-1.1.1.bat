@echo off

rem
rem Copyright (c) 2019 Marat Abrarov (abrarov@gmail.com)
rem
rem Distributed under the MIT License (see accompanying LICENSE)
rem

set exit_code=0

set "PATH=%ACTIVE_PERL_HOME%\bin;%PATH%"

call "%MSVC_BUILD_DIR%\%MSVC_CMD_BOOTSTRAP%"
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

if not "--%OPENSSL_PATCH_FILE%" == "--" (
  "%MSYS_HOME%\usr\bin\patch.exe" -uNf -p0 -i "%OPENSSL_PATCH_FILE%"
  set exit_code=%errorlevel%
  if %exit_code% neq 0 goto exit
)

perl Configure "%OPENSSL_TOOLSET%" --prefix="%OPENSSL_STAGE_DIR%" "%OPENSSL_BUILD_STR_PLAIN%" no-asm "%OPENSSL_CONFIGURE_LINKAGE%"
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

nmake
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

if not "--%OPENSSL_TEST%" == "--" (
  nmake test
  set exit_code=%errorlevel%
  if %exit_code% neq 0 goto exit
)

nmake install
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

:exit
exit /B %exit_code%
