@echo off

rem
rem Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
rem
rem Distributed under the Boost Software License, Version 1.0. (See accompanying
rem file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
rem

set PATH=%MINGW_HOME%\bin;%PERL_HOME%\bin;%PYTHON_HOME%;%MSYS_HOME%\usr\bin;%PATH%
if errorlevel 1 goto exit

if not "--%QT_PATCH_MSYS_FILE%" == "--" (
  patch -uNf -i "%QT_PATCH_MSYS_FILE%"
  if errorlevel 1 goto exit
)

rem call "configure.bat" -mp -platform win32-g++ -debug-and-release -opensource -confirm-license ^
rem -static -opengl desktop -qt-zlib -icu -qt-libpng -qt-libjpeg ^
rem -qt-sql-sqlite -gnu-iconv -nomake examples ^
rem -I "%ICU_DIR%\include" -L "%ICU_DIR%\lib" ^
rem -I "%OPENSSL_DIR%\include" -L "%OPENSSL_DIR%\lib" ^
rem -prefix "%QT_INSTALL_DIR%"
rem if errorlevel 1 goto exit

rem mingw32-make
rem if errorlevel 1 goto exit

rem mingw32-make install
rem if errorlevel 1 goto exit

:exit