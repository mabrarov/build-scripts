@echo off

rem
rem Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
rem
rem Distributed under the MIT License (see accompanying LICENSE)
rem

set exit_code=0

set "PATH=%MINGW_HOME%\bin;%ACTIVE_PERL_HOME%\bin;%PYTHON2_HOME%;%PYTHON2_HOME%\Scripts;%PATH%"

if not "--%QT_OPENSSL_DIR%" == "--" (
  set "PATH=%QT_OPENSSL_DIR%\bin;%PATH%"
  set exit_code=%errorlevel%
  if %exit_code% neq 0 goto exit
)

if not "--%QT_ICU_DIR%" == "--" (
  set "PATH=%QT_ICU_DIR%\bin;%QT_ICU_DIR%\lib;%PATH%"
  set exit_code=%errorlevel%
  if %exit_code% neq 0 goto exit
)

set "LANG=en"

if not "--%QT_PATCH_MSYS_FILE%" == "--" (
  echo Patching Qt with %QT_PATCH_MSYS_FILE%
  "%MSYS_HOME%\usr\bin\patch.exe" -uNf -p0 -i "%QT_PATCH_MSYS_FILE%"
  set exit_code=%errorlevel%
  if %exit_code% neq 0 goto exit
)

call configure.bat ^
  -platform win32-g++ ^
  -debug-and-release ^
  -opensource -confirm-license ^
  "%QT_CONFIGURE_OPTIONS_LINKAGE%" ^
  -feature-relocatable ^
  -nomake examples ^
  -nomake tests ^
  %QT_CONFIGURE_OPTIONS% ^
  %QT_CONFIGURE_OPTIONS_DIRS% ^
  -prefix "%QT_INSTALL_DIR%"
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

mingw32-make%MINGW32_MAKE_OPTIONS%
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

mingw32-make install
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

:exit
exit /B %exit_code%
