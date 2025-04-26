@echo off

rem
rem Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
rem
rem Distributed under the MIT License (see accompanying LICENSE)
rem

set exit_code=0

set "PATH=%NASM_HOME%;%MINGW_HOME%\bin;%MSYS_HOME%\usr\bin;%PATH%"

for /f "tokens=*" %%a in ('cygpath "%OPENSSL_INSTALL_DIR%"') do set openssl_install_dir_msys=%%a
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

cd /d "%OPENSSL_BUILD_DIR%"
perl "%OPENSSL_HOME%/Configure" --prefix="%openssl_install_dir_msys%" --openssldir="%openssl_install_dir_msys%/ssl" "%OPENSSL_BUILD_TYPE_CONFIG%" "%OPENSSL_TOOLSET%" "%OPENSSL_LINKAGE_CONFIG%"
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

make
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

if not "--%OPENSSL_TEST%" == "--" (
  make test
  set exit_code=%errorlevel%
  if %exit_code% neq 0 goto exit
)

make install
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

:exit
exit /B %exit_code%
