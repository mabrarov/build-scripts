@echo off

rem
rem Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
rem
rem Distributed under the MIT License (see accompanying LICENSE)
rem

set exit_code=0

set PATH=%MINGW_HOME%\bin;%ACTIVE_PERL_HOME%\bin;%PYTHON_HOME%;%MSYS_HOME%\usr\bin;%PATH%
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

set LANG="en"
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

if not "--%QT_PATCH_MSYS_FILE%" == "--" (
  echo Patching Qt with %QT_PATCH_MSYS_FILE%
  patch.exe -uNf -p0 -i "%QT_PATCH_MSYS_FILE%"
  set exit_code=%errorlevel%
  if %exit_code% neq 0 goto exit
)

call "configure.bat" ^
-platform win32-g++ ^
-debug-and-release ^
-opensource -confirm-license ^
%QT_CONFIGURE_OPTIONS_LINKAGE% ^
-nomake examples ^
-nomake tests ^
%QT_CONFIGURE_OPTIONS% ^
-I "%OPENSSL_DIR%\include" -L "%OPENSSL_DIR%\lib" ^
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