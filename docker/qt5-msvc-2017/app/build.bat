@echo off

rem
rem Copyright (c) 2019 Marat Abrarov (abrarov@gmail.com)
rem
rem Distributed under the MIT License (see accompanying LICENSE)
rem

set exit_code=0

set PATH=%JOM_HOME%;%OPENSSL_DIR%\bin;%ICU_DIR%\bin;%ICU_DIR%\lib;%ACTIVE_PERL_HOME%\bin;%PYTHON2_HOME%;%PYTHON2_HOME%\Scripts;%PATH%
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

call "%MSVC_BUILD_DIR%\%MSVC_CMD_BOOTSTRAP%"
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

set LANG="en"
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

if not "--%QT_PATCH_MSYS_FILE%" == "--" (
  echo Patching Qt with %QT_PATCH_MSYS_FILE%
  "%MSYS_HOME%\usr\bin\patch.exe" -uNf -p0 -i "%QT_PATCH_MSYS_FILE%"
  set exit_code=%errorlevel%
  if %exit_code% neq 0 goto exit
)

call "configure.bat" ^
  -platform win32-msvc ^
  -debug-and-release ^
  -opensource -confirm-license ^
  "%QT_CONFIGURE_OPTIONS_LINKAGE%" ^
  -nomake examples ^
  -nomake tests ^
  %QT_CONFIGURE_OPTIONS% ^
  -I "%OPENSSL_DIR%\include" ^
  -L "%OPENSSL_DIR%\lib" ^
  -I "%ICU_DIR%\include" ^
  -L "%ICU_DIR%\lib" ^
  -prefix "%QT_INSTALL_DIR%"
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

jom%JOM_BUILD_OPTIONS%
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

jom install
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

:exit
exit /B %exit_code%