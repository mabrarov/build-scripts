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

if not "--%ICU_PATCH_MSYS_FILE%" == "--" (
  patch -uNf -p0 -i "%ICU_PATCH_MSYS_FILE%"
  set exit_code=%errorlevel%
  if %exit_code% neq 0 goto exit
)

bash -C ./runConfigureICU ^
  %ICU_CONFIGURE_OPTIONS% ^
  %ICU_PLATFORM% ^
  --prefix="%ICU_STAGE_MSYS_DIR%" ^
  --build="%ICU_BUILD_MACHINE%" ^
  %ICU_BUILD_OPTIONS%
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

make
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

if not "--%ICU_TEST%" == "--" (
  make check
  set exit_code=%errorlevel%
  if %exit_code% neq 0 goto exit
)

make install
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

:exit
exit /B %exit_code%
