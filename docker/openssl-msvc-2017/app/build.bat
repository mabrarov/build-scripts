@echo off

rem
rem Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
rem
rem Distributed under the MIT License (see accompanying LICENSE)
rem

call "%MSVC_BUILD_DIR%\%MSVC_CMD_BOOTSTRAP%"
if errorlevel 1 goto exit

set PATH=%PATH%;%PERL_HOME%\bin
if errorlevel 1 goto exit

if "%OPENSSL_LINKAGE%" == "shared" (
  perl "%OPENSSL_HOME%\Configure" --prefix=%OPENSSL_STAGE_DIR% %OPENSSL_TOOLSET% no-asm
) else (
  perl "%OPENSSL_HOME%\Configure" --prefix=%OPENSSL_STAGE_DIR% %OPENSSL_TOOLSET% enable-static-engine no-asm no-shared
)
if errorlevel 1 goto exit

call "%OPENSSL_HOME%\ms\%OPENSSL_BOOTSTRAP%"
if errorlevel 1 goto exit

nmake -f "%OPENSSL_HOME%\ms\%OPENSSL_MAKE_FILE%" install
if errorlevel 1 goto exit

:exit
