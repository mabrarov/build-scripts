@echo off

rem
rem Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
rem
rem Distributed under the Boost Software License, Version 1.0. (See accompanying
rem file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
rem

call "%MSVC_BUILD_DIR%\%MSVC_CMD_BOOTSTRAP%"
if errorlevel 1 goto exit

set PATH=%PATH%;%MSYS_HOME%\usr\bin
if errorlevel 1 goto exit

if not "--%ICU_CONFIGURE_PATCH_MSYS_FILE%" == "--" (
  patch -uNf -i "%ICU_CONFIGURE_PATCH_MSYS_FILE%"
)

bash -C ./runConfigureICU %ICU_CONFIGURE_OPTIONS% %ICU_PLATFORM% --prefix=%ICU_STAGE_MSYS_DIR% --build=%ICU_BUILD_MACHINE% %AUTOTOOLS_OPTIONS%
if errorlevel 1 goto exit

make
if errorlevel 1 goto exit

make install

:exit