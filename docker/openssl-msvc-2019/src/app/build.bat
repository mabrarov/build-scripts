@echo off

rem
rem Copyright (c) 2019 Marat Abrarov (abrarov@gmail.com)
rem
rem Distributed under the MIT License (see accompanying LICENSE)
rem

set exit_code=0

set "PATH=%STRAWBERRY_PERL_HOME%\perl\bin;%NASM_HOME%;%PATH%"

call "%MSVC_BUILD_DIR%\%MSVC_CMD_BOOTSTRAP%"
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

cd /d "%OPENSSL_BUILD_DIR%"
perl "%OPENSSL_HOME%\Configure" --prefix="%OPENSSL_INSTALL_DIR%" --openssldir="%OPENSSL_INSTALL_DIR%\ssl" "%OPENSSL_BUILD_TYPE_CONFIG%" "%OPENSSL_TOOLSET%" "%OPENSSL_LINKAGE_CONFIG%"
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
