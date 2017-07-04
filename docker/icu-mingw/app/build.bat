@echo off

rem
rem Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
rem
rem Distributed under the Boost Software License, Version 1.0. (See accompanying
rem file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
rem

set PATH=%MSYS_HOME%\usr\bin;%MINGW_HOME%\bin;%PATH%
if errorlevel 1 goto exit

if not "--%ICU_CONFIGURE_PATCH_MSYS_FILE%" == "--" (
  patch -uNf -i "%ICU_CONFIGURE_PATCH_MSYS_FILE%"
)

if "%ICU_LINKAGE%" == "shared" (
  bash -C ./runConfigureICU %ICU_BUILD_TYPE_OPTIONS% MinGW --prefix=%ICU_STAGE_MSYS_DIR% --build=%ICU_BUILD_MACHINE%
) else (
  bash -C ./runConfigureICU %ICU_BUILD_TYPE_OPTIONS% --static-runtime MinGW --prefix=%ICU_STAGE_MSYS_DIR% --build=%ICU_BUILD_MACHINE% --enable-static --disable-shared
)
if errorlevel 1 goto exit

make
if errorlevel 1 goto exit

make install

:exit