@echo off

rem
rem Copyright (c) 2019 Marat Abrarov (abrarov@gmail.com)
rem
rem Distributed under the MIT License (see accompanying LICENSE)
rem

set exit_code=0

set "PATH=%MSYS_HOME%\usr\bin;%PYTHON3_HOME%;%PYTHON3_HOME%\Scripts;%PATH%"

call "%MSVC_BUILD_DIR%\%MSVC_CMD_BOOTSTRAP%"
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

for /f "tokens=*" %%a in ('cygpath "%ICU_INSTALL_DIR%"') do set icu_install_dir_msys=%%a
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

cd /d "%ICU_HOME%\source"

bash -C ./runConfigureICU ^
  %ICU_CONFIGURE_OPTIONS% ^
  "%ICU_PLATFORM%" ^
  --prefix="%icu_install_dir_msys%" ^
  --build="%ICU_BUILD_MACHINE%" ^
  %ICU_BUILD_OPTIONS%
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

rem Workaround for https://unicode-org.atlassian.net/browse/ICU-20531
mkdir "data\out\tmp"
rem Workaround for https://unicode-org.atlassian.net/browse/ICU-22417
mkdir "data\out\tmp\dirs.timestamp"
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

make
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

if not "--%ICU_TEST%" == "--" (
  set "ICU_DATA=%ICU_HOME%\source\data\out/"
  make check
  set exit_code=%errorlevel%
  if %exit_code% neq 0 goto exit
)

make install
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

:exit
exit /B %exit_code%
