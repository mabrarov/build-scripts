@echo off

rem
rem Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
rem
rem Distributed under the Boost Software License, Version 1.0. (See accompanying
rem file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
rem

set PATH=%MINGW_HOME%\bin;%PATH%
if errorlevel 1 goto exit

set BUILD_TYPE=
if "%OPENSSL_BUILD_TYPE%" == "debug" (
  set BUILD_TYPE=debug
) else (
  set BUILD_TYPE=
)
if errorlevel 1 goto exit

if "%OPENSSL_LINKAGE%" == "shared" (
  bash --login -c "cd %OPENSSL_MSYS_HOME% && perl Configure --prefix=%OPENSSL_INSTALL_MSYS_DIR% %OPENSSL_TOOLSET% %BUILD_TYPE% no-asm shared"
) else (
  bash --login -c "cd %OPENSSL_MSYS_HOME% && perl Configure --prefix=%OPENSSL_INSTALL_MSYS_DIR% %OPENSSL_TOOLSET% %BUILD_TYPE% enable-static-engine no-asm no-shared"
)
if errorlevel 1 goto exit

bash --login -c "cd %OPENSSL_MSYS_HOME% && make depend && make && make install"

:exit