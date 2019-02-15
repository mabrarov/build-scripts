@echo off

rem
rem Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
rem
rem Distributed under the Boost Software License, Version 1.0. (See accompanying
rem file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
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

call "configure.bat" -platform win32-g++ -debug-and-release -opensource -confirm-license ^
-static -opengl desktop -qt-zlib -icu -qt-libpng -qt-libjpeg ^
-nomake examples -nomake tests ^
-I "%ICU_DIR%\include" -L "%ICU_DIR%\lib" ^
-I "%OPENSSL_DIR%\include" -L "%OPENSSL_DIR%\lib" ^
-prefix "%QT_INSTALL_DIR%"
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

mingw32-make
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

mingw32-make install
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

:exit
exit /B %exit_code%